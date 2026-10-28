local Gui = require("src.gui")
local Const = require("src.constants")
local State = require("src.state")
local actions = require("src.actions")

local ToggleRatePrecisionButton = {}

local precisions = {
	[defines.flow_precision_index.five_seconds] = { "five_seconds", { "tpu.precision-five-seconds" } },
	[defines.flow_precision_index.one_minute] = { "one_minute", { "tpu.precision-one-minute" } },
	[defines.flow_precision_index.ten_minutes] = { "ten_minutes", { "tpu.precision-ten-minutes" } },
	[defines.flow_precision_index.one_hour] = { "one_hour", { "tpu.precision-one-hour" } },
	[defines.flow_precision_index.ten_hours] = { "ten_hours", { "tpu.precision-ten-hours" } },
	[defines.flow_precision_index.fifty_hours] = { "fifty_hours", { "tpu.precision-fifty-hours" } },
	[defines.flow_precision_index.two_hundred_fifty_hours] = { "two_hundred_fifty_hours", { "tpu.precision-two-hundred-fifty-hours" } },
	[defines.flow_precision_index.one_thousand_hours] = { "one_thousand_hours", { "tpu.precision-one-thousand-hours" } },
}

local function presentation(player)
	local precision = precisions[State.get(player.index).rate_precision]
	if not precision then
		return "tpu_toggle_rate_precision", { "tpu.precision-unknown" }
	end
	return "tpu_precision_" .. precision[1], { "tpu.precision-tooltip", precision[2] }
end

function ToggleRatePrecisionButton.new(player)
	local sprite, tooltip = presentation(player)
	return Gui.spriteButton({
		name = Const.UI_ID.BTN_TOGGLE_RATE_PRECISION,
		style = "frame_action_button",
		sprite = sprite,
		tooltip = tooltip,
		onClick = actions.TOGGLE_RATE_PRECISION,
		style_mods = {
			size = { 20, 20 },
		},
	})
end

function ToggleRatePrecisionButton.update(element, player)
	local sprite, tooltip = presentation(player)
	element.sprite = sprite
	element.tooltip = tooltip
end

return ToggleRatePrecisionButton
