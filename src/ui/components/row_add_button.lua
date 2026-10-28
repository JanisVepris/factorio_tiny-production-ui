local Gui = require("src.gui")
local Const = require("src.constants")
local actions = require("src.actions")

local RowAddButton = {}

function RowAddButton.new()
	return Gui.spriteButton({
		name = Const.UI_ID.BTN_ROW_ADD,
		style = "frame_action_button",
		sprite = "tpu_triangle_down",
		tooltip = { "tpu.add-row" },
		onClick = actions.ROW_ADD,
		style_mods = {
			size = { 20, 20 },
		},
	})
end

return RowAddButton
