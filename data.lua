local Const = require("src.constants")

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
