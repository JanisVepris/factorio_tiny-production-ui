local Gui = require("src.gui")
local Const = require("src.constants")
local State = require("src.state")

local SlotTypeSwitch = {}

function SlotTypeSwitch.new(player, idx)
	local is_fluid = State.getSlotType(player.index, idx) == "fluid"
	return Gui.switch({
		name = Const.UI_ID.SLOT_TYPE_SWITCH .. idx,
		switch_state = is_fluid and "right" or "left",
		allow_none_state = false,
		tooltip = {
			"tpu.slot-type-current",
			is_fluid and "[virtual-signal=signal-liquid]" or "[virtual-signal=signal-stack-size]",
			{ is_fluid and "tpu.slot-type-fluid" or "tpu.slot-type-item" },
		},
		style_mods = {
			width = 32,
			height = 26,
			padding = 0,
			top_padding = 10,
			margin = 0,
		},
	})
end

return SlotTypeSwitch
