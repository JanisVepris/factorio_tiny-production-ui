local Const = require("src.constants")
local Gui = require("src.gui")
local State = require("src.state")
local Action = require("src.actions")
local MainWindow = require("src.ui.main_window")
local Slot = require("src.ui.components.slot")
local ToggleRatePrecisionButton = require("src.ui.components.toggle_rate_precision_button")
local ToggleModeButton = require("src.ui.components.toggle_mode_button")
local PlanetSelector = require("src.ui.components.planet_selector")
local UnitSelector = require("src.ui.components.unit_selector")
local PauseButton = require("src.ui.components.pause_button")
local is_tpu_slot_chooser = require("src.util.is_tpu_slot_chooser")
local idx_from_name = require("src.util.idx_from_name")
local is_tpu_planet_chooser = require("src.util.is_tpu_planet_chooser")
local snitch = require("src.util.snitch")

local GuiEvents = {}

local function toggleWindow(event)
	local player = game.get_player(event.player_index)
	if player then
		MainWindow.toggle(player)
	end
end

function GuiEvents.init()
	Gui.setEventGuard(function(event)
		local player = game.get_player(event.player_index)
		return player and MainWindow.ensureCurrent(player)
	end)

	Gui.register(Action.REORDER_SLOT, function(event)
		if event.button and event.button ~= defines.mouse_button_type.left then
			return
		end
		local player = game.get_player(event.player_index)
		local idx = event.element.tags.slot_idx
		if not player or not idx then
			return
		end
		local source = State.getReorderSource(player.index)
		if source then
			if source ~= idx then
				State.moveSlot(player.index, source, idx)
			end
			State.cancelSlotMove(player.index)
		else
			State.selectSlotForMove(player.index, idx)
		end
		MainWindow.refreshSlotTable(player)
		MainWindow.updateSlots(player)
	end)

	Gui.register(Action.TOGGLE_ACTION_BUTTONS, function(event)
		local player = game.get_player(event.player_index)
		if player then
			State.toggleActionButtons(player.index)
			MainWindow.updateActionButtonsVisibility(player)
		end
	end)

	Gui.register(Action.TOGGLE_PAUSE, function(event)
		local player = game.get_player(event.player_index)
		if not player then
			return
		end
		local paused = State.togglePause(player.index)
		PauseButton.update(event.element, player)
		if not paused then
			MainWindow.updateSlots(player)
		end
	end)

	script.on_event(defines.events.on_gui_switch_state_changed, function(event)
		local element = event.element
		local prefix = Const.UI_ID.SLOT_TYPE_SWITCH
		if not element or not element.valid or element.name:sub(1, #prefix) ~= prefix then
			return
		end
		local player = game.get_player(event.player_index)
		local idx = idx_from_name(element.name)
		if not player or not idx then
			return
		end
		if not MainWindow.ensureCurrent(player) then
			return
		end
		local slot_type = element.switch_state == "right" and "fluid" or "item"
		if State.setSlotType(player.index, idx, slot_type) then
			local slot = element.parent
			while slot and slot.name ~= Const.UI_ID.SLOT .. idx do
				slot = slot.parent
			end
			if slot then
				Slot.refresh(slot, player)
			end
		end
	end)

	Gui.register(Action.TOGGLE_UNIT, function(event)
		local player = game.get_player(event.player_index)
		if not player then
			return
		end

		State.toggleUnit(player.index)
		UnitSelector.update(event.element, player)
		MainWindow.updateSlots(player)
	end)

	script.on_event(Const.TOGGLE_WINDOW_INPUT, toggleWindow)

	-- Handle shortcut bar button click
	script.on_event(defines.events.on_lua_shortcut, function(event)
		if event.prototype_name ~= Const.UI_ID.BTN_SHORTCUT then
			return
		end

		if Const.DEBUG then
			snitch("Reloading mods")
			game.reload_mods()
		end

		snitch("TPU Shortcut clicked")
		toggleWindow(event)
	end)

	-- Handle element chooser events
	script.on_event(defines.events.on_gui_elem_changed, function(event)
		local element = event.element

		if not element or not element.valid then
			return
		end

		local player = game.get_player(event.player_index)
		if not player then
			return
		end

		-- planet chooser
		if not MainWindow.ensureCurrent(player) then
			return
		end
		if is_tpu_planet_chooser(element.name) then
			snitch({ msg = "Planet chooser event", val = element.elem_value })
			State.setPlanet(player.index, element.elem_value)
			PlanetSelector.update(element, player)
			return
		end

		-- slot elem chooser
		if not is_tpu_slot_chooser(element.name) then
			return
		end

		local idx = idx_from_name(element.name)
		if not idx then
			return
		end

		snitch({ msg = "Slot value change", val = element.elem_value })
		local moving = State.getReorderSource(player.index) ~= nil
		State.setSlotValue(event.player_index, idx, element.elem_value)
		if moving then
			MainWindow.refreshSlotTable(player)
			MainWindow.updateSlots(player)
		else
			Slot.refresh(element.parent, player)
		end
	end)

	-- Update rate labels
	script.on_nth_tick(Const.TICK_INTERVAL, function()
		for _, player in pairs(game.connected_players) do
			if MainWindow.ensureCurrent(player) and not State.isPaused(player.index) then
				MainWindow.updateSlots(player)
			end
		end
	end)

	-- Handle action button clicks
	Gui.register(Action.TOGGLE_RATE_PRECISION, function(event)
		local player = game.get_player(event.player_index)
		if not player then
			return
		end

		State.toggleRatePrecision(event.player_index)
		ToggleRatePrecisionButton.update(event.element, player)
	end)

	-- Toggle total/diff mode
	Gui.register(Action.TOGGLE_MODE, function(event)
		local player = game.get_player(event.player_index)
		if not player then
			return
		end

		State.toggleMode(event.player_index)
		ToggleModeButton.update(event.element, player)
		MainWindow.refreshSlotTable(player)
	end)

	-- Toggle vertical/horizontal orientation
	Gui.register(Action.TOGGLE_ORIENTATION, function(event)
		local player = game.get_player(event.player_index)
		if not player then
			return
		end

		State.toggleOrientation(event.player_index)
		MainWindow.refresh(player)
	end)

	-- Add column
	Gui.register(Action.COL_ADD, function(event)
		local player = game.get_player(event.player_index)

		if not player then
			return
		end

		State.colAdd(event.player_index)
		MainWindow.refreshActionButtons(player)
		MainWindow.refreshSlotTable(player)
	end)

	-- Remove column
	Gui.register(Action.COL_SUB, function(event)
		local player = game.get_player(event.player_index)

		if not player then
			return
		end

		State.colSub(event.player_index)
		MainWindow.refreshActionButtons(player)
		MainWindow.refreshSlotTable(player)
	end)

	-- Add row
	Gui.register(Action.ROW_ADD, function(event)
		local player = game.get_player(event.player_index)

		if not player then
			return
		end

		State.rowAdd(event.player_index)
		MainWindow.refreshActionButtons(player)
		MainWindow.refreshSlotTable(player)
	end)

	-- Remove row
	Gui.register(Action.ROW_SUB, function(event)
		local player = game.get_player(event.player_index)

		if not player then
			return
		end

		State.rowSub(event.player_index)
		MainWindow.refreshActionButtons(player)
		MainWindow.refreshSlotTable(player)
	end)
end

return GuiEvents
