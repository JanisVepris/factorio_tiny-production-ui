local Gui = require("src.gui")
local Const = require("src.constants")
local actions = require("src.actions")

local ColAddButton = {}

function ColAddButton.new()
	return Gui.spriteButton({
		name = Const.UI_ID.BTN_COL_ADD,
		style = "frame_action_button",
		sprite = "tpu_triangle_right",
		tooltip = { "tpu.add-column" },
		onClick = actions.COL_ADD,
		style_mods = {
			size = { 20, 20 },
		},
	})
end

return ColAddButton
