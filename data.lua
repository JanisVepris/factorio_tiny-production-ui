local Const = require("src.constants")

local function invisible_scrollbar(style_type)
	return {
		type = style_type,
		background_graphical_set = {},
		thumb_button_style = {
			type = "button_style",
			default_graphical_set = {},
			hovered_graphical_set = {},
			clicked_graphical_set = {},
			disabled_graphical_set = {},
		},
	}
end

-- This pane also clips the hidden content to one pixel. Its scrollbars and
-- borders must draw nothing, including any graphics outside the clipping area.
data.raw["gui-style"].default.tpu_content_viewport = {
	type = "scroll_pane_style",
	parent = "naked_scroll_pane",
	padding = 0,
	margin = 0,
	extra_padding_when_activated = 0,
	dont_force_clipping_rect_for_contents = false,
	graphical_set = {},
	background_graphical_set = {},
	horizontal_scrollbar_style = invisible_scrollbar("horizontal_scrollbar_style"),
	vertical_scrollbar_style = invisible_scrollbar("vertical_scrollbar_style"),
}

local function toggle_background(field, color)
	local styles = data.raw["gui-style"].default
	local style = styles.frame_action_button
	while not style[field] do
		style = styles[style.parent]
	end
	local graphics = table.deepcopy(style[field])
	graphics.base.tint = color
	if graphics.glow then
		graphics.glow.tint = color
	end
	return graphics
end

for name, color in pairs({
	tpu_action_buttons_visible = { 1, 0.6, 0.15 },
	tpu_action_buttons_hidden = { 0.2, 0.9, 0.2 },
}) do
	data.raw["gui-style"].default[name] = {
		type = "button_style",
		parent = "frame_action_button",
		default_graphical_set = toggle_background("default_graphical_set", color),
		hovered_graphical_set = toggle_background("hovered_graphical_set", color),
		clicked_graphical_set = toggle_background("clicked_graphical_set", color),
	}
end

data.raw["gui-style"].default.tpu_vertical_drag_handle = {
	type = "empty_widget_style",
	parent = "draggable_space_header",
	graphical_set = {
		base = {
			type = "composition",
			center = {
				filename = "__tiny-production-ui__/img/vertical-drag-handle.png",
				width = 8,
				height = 4,
			},
			overall_tiling_vertical_size = 4,
		},
		shadow = data.raw["gui-style"].default.draggable_space.graphical_set.shadow,
	},
}

for _, precision in ipairs({
	"five_seconds",
	"one_minute",
	"ten_minutes",
	"one_hour",
	"ten_hours",
	"fifty_hours",
	"two_hundred_fifty_hours",
	"one_thousand_hours",
}) do
	data:extend({
		{
			type = "sprite",
			name = "tpu_precision_" .. precision,
			filename = "__tiny-production-ui__/img/precision-" .. precision:gsub("_", "-") .. ".png",
			width = 32,
			height = 32,
		},
	})
end

data:extend({
	{
		type = "sprite",
		name = "tpu_eye_open",
		filename = "__tiny-production-ui__/img/eye-open.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "tpu_eye_closed",
		filename = "__tiny-production-ui__/img/eye-closed.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "tpu_pause_red",
		filename = "__tiny-production-ui__/img/pause-red.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "tpu_play_green",
		filename = "__tiny-production-ui__/img/play-green.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "tpu_unit_items",
		filename = "__tiny-production-ui__/img/unit-items.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "tpu_unit_stacks",
		filename = "__tiny-production-ui__/img/unit-stacks.png",
		width = 32,
		height = 32,
	},
	{
		type = "custom-input",
		name = Const.TOGGLE_WINDOW_INPUT,
		key_sequence = "",
		action = "lua",
		consuming = "none",
	},
	{
		type = "sprite",
		name = "tpu_mode_total",
		filename = "__tiny-production-ui__/img/mode-diff.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "tpu_mode_diff",
		filename = "__tiny-production-ui__/img/mode-net.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "tpu_toggle_orientation",
		filename = "__tiny-production-ui__/img/toggle-orientation.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "tpu_toggle_rate_precision",
		filename = "__tiny-production-ui__/img/toggle-rate-precision.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "tpu_triangle_up",
		filename = "__tiny-production-ui__/img/triangle-up.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "tpu_triangle_right",
		filename = "__tiny-production-ui__/img/triangle-right.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "tpu_triangle_left",
		filename = "__tiny-production-ui__/img/triangle-left.png",
		width = 32,
		height = 32,
	},
	{
		type = "sprite",
		name = "tpu_triangle_down",
		filename = "__tiny-production-ui__/img/triangle-down.png",
		width = 32,
		height = 32,
	},
	{
		type = "shortcut",
		name = Const.UI_ID.BTN_SHORTCUT,
		action = "lua",
		toggleable = true,
		associated_control_input = Const.TOGGLE_WINDOW_INPUT,

		icon = "__tiny-production-ui__/img/shortcut-icon.png",
		icon_size = 1254,

		small_icon = "__tiny-production-ui__/img/shortcut-icon.png",
		small_icon_size = 1254,
	},
})
