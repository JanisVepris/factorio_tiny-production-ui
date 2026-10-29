local Gui = require("src.gui")
local Const = require("src.constants")
local State = require("src.state")
local Action = require("src.actions")

local AutoHideButton = {}

local function presentation(player)
	if State.isAutoHideEnabled(player.index) then
		return "tpu_eye_closed", { "tpu.auto-hide-on" }
	end
	return "tpu_eye_open", { "tpu.auto-hide-off" }
end

function AutoHideButton.new(player)
	local sprite, tooltip = presentation(player)
	return Gui.spriteButton({
		name = Const.UI_ID.BTN_AUTO_HIDE,
		style = "frame_action_button",
		sprite = sprite,
		tooltip = tooltip,
		onClick = Action.TOGGLE_AUTO_HIDE,
		style_mods = { size = { 20, 20 } },
	})
end

function AutoHideButton.update(element, player)
	element.sprite, element.tooltip = presentation(player)
end

return AutoHideButton
