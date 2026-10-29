local gui = require("src.gui")
local constants = require("src.constants")
local State = require("src.state")
local Action = require("src.actions")
local TitleBar = {}

local function dragHandle(name, horizontal)
	local style_mods = {
		horizontally_stretchable = not horizontal,
		vertically_stretchable = horizontal,
		padding = 0,
		margin = 0,
	}
	if horizontal then
		style_mods.width = 10
		style_mods.minimal_height = 0
	else
		style_mods.height = 10
		style_mods.minimal_width = 0
	end

	return gui.emptyWidget({
		name = name,
		style = horizontal and "tpu_vertical_drag_handle" or "draggable_space_header",
		style_mods = style_mods,
	})
end

local function presentation(player)
	local visible = State.areActionButtonsVisible(player.index)
	return visible and "tpu_action_buttons_visible" or "tpu_action_buttons_hidden",
		{ visible and "tpu.hide-action-buttons" or "tpu.show-action-buttons" }
end

function TitleBar.new(player)
	local horizontal = State.getOrientation(player.index) == "horizontal"
	local style, tooltip = presentation(player)
	return gui.flow({
		name = constants.UI_ID.TITLE_BAR_CONTAINER,
		direction = horizontal and "vertical" or "horizontal",
		style_mods = {
			horizontally_stretchable = not horizontal,
			vertically_stretchable = horizontal,
			[horizontal and "vertical_spacing" or "horizontal_spacing"] = 0,
			padding = 0,
			margin = 0,
		},
		children = {
			dragHandle(constants.UI_ID.TITLE_BAR_DRAG_START, horizontal),
			gui.spriteButton({
				name = constants.UI_ID.BTN_TOGGLE_ACTION_BUTTONS,
				style = style,
				tooltip = tooltip,
				onClick = Action.TOGGLE_ACTION_BUTTONS,
				style_mods = {
					size = horizontal and { 8, 24 } or { 24, 8 },
					padding = 0,
				},
			}),
			dragHandle(constants.UI_ID.TITLE_BAR_DRAG_END, horizontal),
		},
	})
end

function TitleBar.update(element, player)
	local style, tooltip = presentation(player)
	local button = element[constants.UI_ID.BTN_TOGGLE_ACTION_BUTTONS]
	button.style = style
	-- Changing a style resets runtime overrides.
	button.style.size = State.getOrientation(player.index) == "horizontal" and { 8, 24 } or { 24, 8 }
	button.style.padding = 0
	button.tooltip = tooltip
end

function TitleBar.setDragTarget(element, window)
	element[constants.UI_ID.TITLE_BAR_DRAG_START].drag_target = window
	element[constants.UI_ID.TITLE_BAR_DRAG_END].drag_target = window
end

return TitleBar
