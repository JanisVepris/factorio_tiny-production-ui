local Gui = require("src.gui")
local Const = require("src.constants")
local actions = require("src.actions")

local RowSubButton = {}

function RowSubButton.new()
	return Gui.spriteButton({
		name = Const.UI_ID.BTN_ROW_SUB,
		style = "frame_action_button",
		sprite = "tpu_triangle_up",
		tooltip = { "tpu.remove-row" },
		onClick = actions.ROW_SUB,
		style_mods = {
			size = { 20, 20 },
		},
	})
end

return RowSubButton
