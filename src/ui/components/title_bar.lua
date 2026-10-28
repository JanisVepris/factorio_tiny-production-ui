local gui = require("src.gui")
local constants = require("src.constants")
local TitleBar = {}

function TitleBar.new()
	return gui.emptyWidget({
		name = constants.UI_ID.TITLE_BAR_CONTAINER,
		style = "draggable_space_header",
		style_mods = {
			height = 10,
			minimal_width = 10,
			horizontally_stretchable = true,
			vertically_stretchable = false,
			padding = 0,
			margin = 0,
		},
	})
end

function TitleBar.setDragTarget(element, window)
	element.drag_target = window
end

return TitleBar
