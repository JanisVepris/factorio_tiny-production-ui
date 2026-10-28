local Gui = require("src.gui")
local Const = require("src.constants")
local State = require("src.state")
local actions = require("src.actions")

local ToggleModeButton = {}

local function presentation(player)
	if State.get(player.index).mode == "diff" then
		return "tpu_mode_diff", { "tpu.mode-diff" }
	end
	return "tpu_mode_total", { "tpu.mode-total" }
end

function ToggleModeButton.new(player)
	local sprite, tooltip = presentation(player)
	return Gui.spriteButton({
		name = Const.UI_ID.BTN_TOGGLE_MODE,
		style = "frame_action_button",
		sprite = sprite,
		tooltip = tooltip,
		onClick = actions.TOGGLE_MODE,
		style_mods = {
			size = { 20, 20 },
		},
	})
end

function ToggleModeButton.update(element, player)
	local sprite, tooltip = presentation(player)
	element.sprite = sprite
	element.tooltip = tooltip
end

return ToggleModeButton
