local Gui = require("src.gui")
local Const = require("src.constants")
local actions = require("src.actions")

local ColSubButton = {}

function ColSubButton.new()
	return Gui.spriteButton({
		name = Const.UI_ID.BTN_COL_SUB,
		style = "frame_action_button",
		sprite = "tpu_triangle_left",
		tooltip = { "tpu.remove-column" },
		onClick = actions.COL_SUB,
		style_mods = {
			size = { 20, 20 },
		},
	})
end

return ColSubButton
