local Const = require("src.constants")
local Units = require("src.units")
local snitch = require("src.util.snitch")

---@alias Orientation 'vertical'|'horizontal'
---@alias DisplayMode 'diff'|'total'

---@class PlayerState
---@field orientation Orientation
---@field mode DisplayMode
---@field unit string
---@field columns integer
---@field rows integer
---@field rate_precision unknown
---@field slots table<integer, string>
---@field slot_types table<integer, string>?
---@field planet string?
---@field window_location GuiLocation?
---@field paused boolean

local State = {}

local rate_precisions = {
	defines.flow_precision_index.five_seconds,
	defines.flow_precision_index.one_minute,
	defines.flow_precision_index.ten_minutes,
	defines.flow_precision_index.one_hour,
	defines.flow_precision_index.ten_hours,
	defines.flow_precision_index.fifty_hours,
	defines.flow_precision_index.two_hundred_fifty_hours,
	defines.flow_precision_index.one_thousand_hours,
}

function State.init()
	storage.players = storage.players or {}
end

---@param player_index integer
---@return PlayerState
function State.get(player_index)
	local players = storage.players

	if not players[player_index] then
		return State.default(player_index)
	end

	return players[player_index]
end

---@param player_index integer
---@return PlayerState
function State.default(player_index)
	local state = {
		orientation = Const.DEFAULTS.ORIENTATION,
		mode = Const.DEFAULTS.MODE,
		unit = Const.DEFAULTS.UNIT,
		rows = Const.DEFAULTS.ROWS,
		columns = Const.DEFAULTS.COLUMNS,
		rate_precision = Const.DEFAULTS.RATE_PRECISION,
		slots = {},
		slot_types = {},
		paused = false,
	}

	storage.players[player_index] = state

	return State.get(player_index)
end

---@param player_index integer
function State.isPaused(player_index)
	return State.get(player_index).paused == true
end

---@param player_index integer
function State.togglePause(player_index)
	local paused = not State.isPaused(player_index)
	State.get(player_index).paused = paused
	return paused
end

---@param player_index integer
function State.getUnit(player_index)
	return Units.get(State.get(player_index).unit or Const.DEFAULTS.UNIT).id
end

---@param player_index integer
function State.toggleUnit(player_index)
	local unit = Units.next(State.getUnit(player_index))
	State.get(player_index).unit = unit
	return unit
end

---@param player_index integer
function State.getOrientation(player_index)
	return State.get(player_index).orientation
end

---@param player_index integer
---@param mode DisplayMode
function State.setMode(player_index, mode)
	snitch("Setting mode" .. mode)
	State.get(player_index).mode = mode
end

---@param player_index integer
function State.toggleMode(player_index)
	if State.get(player_index).mode == "diff" then
		State.setMode(player_index, "total")
	else
		State.setMode(player_index, "diff")
	end
end

---@param player_index integer
function State.toggleOrientation(player_index)
	if State.get(player_index).orientation == "vertical" then
		State.get(player_index).orientation = "horizontal"
	else
		State.get(player_index).orientation = "vertical"
	end
end

---@param player_index integer
function State.toggleRatePrecision(player_index)
	local state = State.get(player_index)

	for index, precision in ipairs(rate_precisions) do
		if state.rate_precision == precision then
			state.rate_precision = rate_precisions[index % #rate_precisions + 1]
			return state.rate_precision
		end
	end

	state.rate_precision = rate_precisions[1]
	return state.rate_precision
end

---@param player_index integer
function State.getColumns(player_index)
	if State.get(player_index).orientation == "horizontal" then
		return State.get(player_index).rows
	end
	return State.get(player_index).columns
end

---@param player_index integer
---@param columns integer
function State.setColumns(player_index, columns)
	State.get(player_index).columns = columns
end

---@param player_index integer
function State.colAdd(player_index)
	if State.get(player_index).columns < 100 then
		State.setColumns(player_index, State.get(player_index).columns + 1)
	end
end

---@param player_index integer
function State.colSub(player_index)
	if State.get(player_index).columns > 1 then
		State.setColumns(player_index, State.get(player_index).columns - 1)
	end
end

---@param player_index integer
function State.getRows(player_index)
	if State.get(player_index).orientation == "horizontal" then
		return State.get(player_index).columns
	end
	return State.get(player_index).rows
end

---@param player_index integer
---@param rows integer
function State.setRows(player_index, rows)
	State.get(player_index).rows = rows
end

---@param player_index integer
function State.rowAdd(player_index)
	if State.get(player_index).rows < 100 then
		State.setRows(player_index, State.get(player_index).rows + 1)
	end
end

---@param player_index integer
function State.rowSub(player_index)
	if State.get(player_index).rows > 1 then
		State.setRows(player_index, State.get(player_index).rows - 1)
	end
end

---@param player_index integer
---@param slot_idx number
function State.getSlotType(player_index, slot_idx)
	local types = State.get(player_index).slot_types
	return types and types[slot_idx] or "item"
end

---@param player_index integer
---@param slot_idx integer
---@param slot_type 'item'|'fluid'
function State.setSlotType(player_index, slot_idx, slot_type)
	assert(slot_type == "item" or slot_type == "fluid", "Invalid slot type")
	local player_state = State.get(player_index)
	if player_state.slots[slot_idx] then
		return false
	end
	player_state.slot_types = player_state.slot_types or {}
	player_state.slot_types[slot_idx] = slot_type
	return true
end

---@param player_index integer
---@param slot_idx integer
---@param value string?
function State.setSlotValue(player_index, slot_idx, value)
	State.get(player_index).slots[slot_idx] = value
end

---@param player_index integer
---@param planet string?
function State.setPlanet(player_index, planet)
	State.get(player_index).planet = planet
end

---@param player_index integer
---@return string?
function State.getPlanet(player_index)
	return State.get(player_index).planet
end
return State
