local gui = require("src.gui")
local constants = require("src.constants")
local State = require("src.state")
local TitleBar = {}

function TitleBar.new(player)
	local horizontal = State.getOrientation(player.index) == "horizontal"
	local style_mods = {
		horizontally_stretchable = not horizontal,
		vertically_stretchable = horizontal,
		padding = 0,
		margin = 0,
	}
	if horizontal then
		style_mods.width = 10
		style_mods.minimal_height = 10
	else
		style_mods.height = 10
		style_mods.minimal_width = 10
	end

	return gui.emptyWidget({
		name = constants.UI_ID.TITLE_BAR_CONTAINER,
		style = horizontal and "tpu_vertical_drag_handle" or "draggable_space_header",
		style_mods = style_mods,
	})
end

function TitleBar.setDragTarget(element, window)
	element.drag_target = window
end

return TitleBar
