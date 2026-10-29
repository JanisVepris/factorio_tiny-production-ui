local Gui = require("src.gui")
local Const = require("src.constants")
local State = require("src.state")
local Action = require("src.actions")

local PauseButton = {}

local function presentation(player)
	if State.isPaused(player.index) then
		return "tpu_play_green", { "tpu.resume-updates" }
	end
	return "tpu_pause_red", { "tpu.pause-updates" }
end

function PauseButton.new(player)
	local sprite, tooltip = presentation(player)
	return Gui.spriteButton({
		name = Const.UI_ID.BTN_PAUSE,
		style = "frame_action_button",
		sprite = sprite,
		tooltip = tooltip,
		onClick = Action.TOGGLE_PAUSE,
		style_mods = { size = { 20, 20 } },
	})
end

function PauseButton.update(element, player)
	local sprite, tooltip = presentation(player)
	element.sprite = sprite
	element.tooltip = tooltip
end

return PauseButton
