local State = require("src.state")
local Const = require("src.constants")
local Gui = require("src.gui")
local Action = require("src.actions")
local RowAddButton = require("src.ui.components.row_add_button")
local RowSubButton = require("src.ui.components.row_sub_button")
local ColAddButton = require("src.ui.components.col_add_button")
local ColSubButton = require("src.ui.components.col_sub_button")
local ToggleOrientationButton = require("src.ui.components.toggle_orientation_button")
local ToggleRatePrecisionButton = require("src.ui.components.toggle_rate_precision_button")
local ToggleModeButton = require("src.ui.components.toggle_mode_button")
local PlanetSelector = require("src.ui.components.planet_selector")
local UnitSelector = require("src.ui.components.unit_selector")
local PauseButton = require("src.ui.components.pause_button")
local AutoHideButton = require("src.ui.components.auto_hide_button")

local ActionButtons = {}

local horizontal_actions = {
	[Action.ROW_ADD] = Action.COL_ADD,
	[Action.ROW_SUB] = Action.COL_SUB,
	[Action.COL_ADD] = Action.ROW_ADD,
	[Action.COL_SUB] = Action.ROW_SUB,
}

local function direction(player)
	if State.getOrientation(player.index) == "horizontal" then
		return "horizontal"
	end

	if State.getColumns(player.index) >= 3 then
		return "horizontal"
	end

	return "vertical"
end

local function subdirection(player)
	if State.getOrientation(player.index) == "horizontal" then
		return "vertical"
	end

	return "horizontal"
end

local function dimension_buttons(player)
	local buttons = {
		RowSubButton.new(),
		RowAddButton.new(),
		ColSubButton.new(),
		ColAddButton.new(),
	}
	if State.get(player.index).orientation == "horizontal" then
		for _, button in ipairs(buttons) do
			button.onClick = horizontal_actions[button.onClick]
		end
	end
	return buttons
end

function ActionButtons.new(player)
	local first_row = dimension_buttons(player)
	first_row[#first_row + 1] = PauseButton.new(player)
	first_row[#first_row + 1] = AutoHideButton.new(player)
	return Gui.flow({
		name = Const.UI_ID.ACTION_BTN_CONTAINER,
		visible = State.areActionButtonsVisible(player.index),
		direction = direction(player),

		children = {
			Gui.flow({
				name = Const.UI_ID.ACTION_BTN_PART1,
				direction = subdirection(player),
				children = first_row,
			}),

			Gui.flow({
				name = Const.UI_ID.ACTION_BTN_PART2,
				direction = subdirection(player),
				children = {
					ToggleOrientationButton.new(player),
					ToggleRatePrecisionButton.new(player),
					ToggleModeButton.new(player),
					UnitSelector.new(player),
					PlanetSelector.new(player),
				},
			}),
		},
	})
end

function ActionButtons.update(element, player)
	if element.direction == direction(player) then
		local controls = element[Const.UI_ID.ACTION_BTN_PART1]
		for _, definition in ipairs(dimension_buttons(player)) do
			local button = controls[definition.name]
			local tags = button.tags
			tags.action = definition.onClick
			button.tags = tags
		end
		return element
	end

	local parent = element.parent
	local definition = ActionButtons.new(player)
	definition.index = element.get_index_in_parent()
	element.destroy()
	return Gui.render(parent, definition)
end

return ActionButtons
