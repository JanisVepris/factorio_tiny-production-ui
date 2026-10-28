local Gui = require("src.gui")
local Const = require("src.constants")
local State = require("src.state")
local actions = require("src.actions")

local ToggleOrientationButton = {}

local function presentation(player)
	local orientation = State.get(player.index).orientation
	if orientation == "vertical" then
		return { "tpu.orientation-vertical" }
	end
	return { "tpu.orientation-horizontal" }
end

function ToggleOrientationButton.new(player)
	local tooltip = presentation(player)
	return Gui.spriteButton({
		name = Const.UI_ID.BTN_TOGGLE_ORIENTATION,
		style = "frame_action_button",
		sprite = "tpu_toggle_orientation",
		tooltip = tooltip,
		onClick = actions.TOGGLE_ORIENTATION,
		style_mods = {
			size = { 20, 20 },
		},
	})
end


return ToggleOrientationButton
