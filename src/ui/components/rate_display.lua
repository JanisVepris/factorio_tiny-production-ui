local Const = require("src.constants")
local Gui = require("src.gui")
local State = require("src.state")
local format_number = require("src.util.format_number")
local get_production_stats = require("src.util.get_production_stats")

local RateDisplay = {}

local function color(value)
	if value > 0 then
		return { r = 0.2, g = 0.9, b = 0.2 }
	elseif value < 0 then
		return { r = 0.9, g = 0.2, b = 0.2 }
	else
		return { r = 1.0, g = 0.7, b = 0 }
	end
end

local function sign(value, type)
	if type == "production" then
		if value > 0 then
			return "+"
		else
			return ""
		end
	elseif type == "consumption" then
		if value > 0 then
			return "-"
		else
			return ""
		end
	elseif type == "diff" then
		if value > 0 then
			return "+"
		elseif value < 0 then
			return ""
		else
			return ""
		end
	end

	return ""
end

local function children(player, idx)
	local item = State.get(player.index).slots[idx]

	if not item then
		return {
			Gui.label({
				name = Const.UI_ID.RATE_TOTAL_PRODUCTION .. idx,
				caption = { "tpu.not-available" },
				tooltip = "",
				style_mods = {
					font_color = color(0),
					font = Const.RATE_FONT_STYLE,
					padding = 0,
					top_padding = 10,
				},
			}),
		}
	end

	if State.get(player.index).mode == "total" then
		return {
			Gui.label({
				name = Const.UI_ID.RATE_TOTAL_PRODUCTION .. idx,
				caption = { "tpu.not-available" },
				tooltip = { "tpu.production-tooltip" },
				style_mods = {
					font_color = color(0),
					font = Const.RATE_FONT_STYLE,
					padding = 0,
				},
			}),
			Gui.label({
				name = Const.UI_ID.RATE_TOTAL_CONSUMPTION .. idx,
				caption = { "tpu.not-available" },
				tooltip = { "tpu.consumption-tooltip" },
				style_mods = {
					font_color = color(0),
					font = Const.RATE_FONT_STYLE,
					padding = 0,
				},
			}),
		}
	end

	return {
		Gui.label({
			name = Const.UI_ID.RATE_DIFF .. idx,
			caption = { "tpu.not-available" },
			tooltip = { "tpu.diff-tooltip" },
			style_mods = {
				font_color = color(0),
				font = "default-small",
				padding = 0,
				top_padding = 10,
			},
		}),
	}
end

function RateDisplay.new(player, idx)
	local element = Gui.flow({
		name = Const.UI_ID.RATE_DISPLAY .. idx,
		direction = "vertical",
		style_mods = {
			vertical_spacing = 0,
			right_padding = 2,
		},
		children = children(player, idx),
	})

	return element
end

function RateDisplay.refresh(element, player, idx)
	element.clear()
	for _, child in ipairs(children(player, idx)) do
		Gui.render(element, child)
	end
	RateDisplay.update(element, player, idx)
end

function RateDisplay.update(element, player, idx)
	local item = State.get(player.index).slots[idx]

	if not item then
		return
	end

	local precision_rate = State.get(player.index).rate_precision

	local production, consumption, diff =
		get_production_stats(player, item, precision_rate, State.getPlanet(player.index))

	if State.get(player.index).mode == "total" then
		local production_label = element[Const.UI_ID.RATE_TOTAL_PRODUCTION .. idx]
		production_label.caption = { "tpu.rate-value", sign(production, "production"), format_number(production) }
		production_label.style.font_color = color(production)

		local consumption_label = element[Const.UI_ID.RATE_TOTAL_CONSUMPTION .. idx]
		consumption_label.caption = { "tpu.rate-value", sign(consumption, "consumption"), format_number(consumption) }
		consumption_label.style.font_color = color(-consumption)
	else
		local diff_label = element[Const.UI_ID.RATE_DIFF .. idx]
		diff_label.caption = { "tpu.rate-value", sign(diff, "diff"), format_number(diff) }
		diff_label.style.font_color = color(diff)
	end
end

return RateDisplay
