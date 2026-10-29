local Gui = require("src.gui")
local Const = require("src.constants")
local State = require("src.state")
local Action = require("src.actions")
local Units = require("src.units")

local UnitSelector = {}

local function tooltip(unit)
	return { "tpu.unit-selector-tooltip", unit.name, Units.get(Units.next(unit.id)).name }
end

function UnitSelector.new(player)
	local unit = Units.get(State.getUnit(player.index))
	return Gui.spriteButton({
		name = Const.UI_ID.BTN_UNIT_SELECTOR,
		style = "frame_action_button",
		sprite = unit.sprite,
		tooltip = tooltip(unit),
		onClick = Action.TOGGLE_UNIT,
		style_mods = {
			size = { 20, 20 },
			padding = 0,
		},
	})
end

function UnitSelector.update(element, player)
	local unit = Units.get(State.getUnit(player.index))
	element.sprite = unit.sprite
	element.tooltip = tooltip(unit)
end

return UnitSelector
