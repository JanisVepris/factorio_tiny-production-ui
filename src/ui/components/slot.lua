local Const = require("src.constants")
local Gui = require("src.gui")
local State = require("src.state")
local RateDisplay = require("src.ui.components.rate_display")
local idx_from_name = require("src.util.idx_from_name")

local Slot = {}

function Slot.new(idx, player)
	local slot_type = State.getSlotType(player.index, idx)
	return Gui.flow({
		name = Const.UI_ID.SLOT .. idx,
		direction = "horizontal",

		style_mods = {
			right_padding = 2,
		},

		children = {
			Gui.elemChooser({
				name = Const.UI_ID.SLOT_CHOOSER .. idx,
				elem_type = slot_type,
				[slot_type] = State.get(player.index).slots[idx],
				style = State.getReorderSource(player.index) == idx and "yellow_slot_button" or "slot_button",
				tooltip = { "tpu.rate-slot", idx },
			}),

			RateDisplay.new(player, idx),
		},
	})
end

function Slot.refresh(element, player)
	local idx = idx_from_name(element.name)
	if not idx then
		return
	end

	element.clear()
	for _, child in ipairs(Slot.new(idx, player).children) do
		Gui.render(element, child)
	end
	Slot.update(element, player)
end

function Slot.update(element, player)
	local idx = idx_from_name(element.name)
	if not idx then
		return
	end

	local chooser = element[Const.UI_ID.SLOT_CHOOSER .. idx]
	local display = element[Const.UI_ID.RATE_DISPLAY .. idx]
	if chooser and chooser.elem_value and display then
		RateDisplay.update(display, player, idx)
	end
end

return Slot
