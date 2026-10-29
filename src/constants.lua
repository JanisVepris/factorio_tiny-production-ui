return {
	DEBUG = false,
	TOGGLE_WINDOW_INPUT = "tpu-toggle-window",

	TICK_INTERVAL = 5,

	RATE_FONT_STYLE = "default-small",

	DEFAULTS = {
		COLUMNS = 2,
		ROWS = 2,
		ORIENTATION = "vertical",
		MODE = "total",
		UNIT = "items",
		RATE_PRECISION = defines.flow_precision_index.ten_minutes,
	},

	UI_ID = {
		BTN_SHORTCUT = "tpu_btn_shortcut",
		MAIN_WINDOW_OUTER = "tpu_main_mindow_outer",
		MAIN_WINDOW = "tpu_main_mindow",
		TITLE_BAR_CONTAINER = "tpu_main_title_bar_container",

		-- Action buttons
		ACTION_BTN_CONTAINER = "tpu_action_btn_container",
		ACTION_BTN_PART1 = "tpu_action_btn_part1",
		ACTION_BTN_PART2 = "tpu_action_btn_part2",
		BTN_ROW_ADD = "tpu_btn_row_add",
		BTN_ROW_SUB = "tpu_btn_row_sub",
		BTN_COL_ADD = "tpu_btn_col_add",
		BTN_COL_SUB = "tpu_btn_col_sub",
		BTN_TOGGLE_MODE = "tpu_btn_toggle_mode",
		BTN_TOGGLE_ORIENTATION = "tpu_btn_toggle_orientation",
		BTN_TOGGLE_RATE_PRECISION = "tpu_btn_toggle_rate_precision",
		BTN_PLANET_SELECTOR = "tpu_btn_planet_selector",
		BTN_UNIT_SELECTOR = "tpu_btn_unit_selector",

		-- Slot table
		SLOT_TABLE = "tpu_slot_table",
		SLOT_OUTER_FRAME = "tpu_slot_outer_frame",
		SLOT = "tpu_slot_",
		SLOT_CHOOSER = "tpu_slot_chooser_",
		SLOT_TYPE_SWITCH = "tpu_slot_type_switch_",
		RATE_DISPLAY = "rate_display_",
		RATE_TOTAL_PRODUCTION = "rate_total_production_",
		RATE_TOTAL_CONSUMPTION = "rate_total_production_consumption_",
		RATE_DIFF = "rate_diff_production_",
	},
}
