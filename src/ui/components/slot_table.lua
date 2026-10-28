local Const = require("src.constants")
local Gui = require("src.gui")
local State = require("src.state")
local Slot = require("src.ui.components.slot")

local SlotTable = {}

function SlotTable.new(player)
	local cols = State.getColumns(player.index)
	local rows = State.getRows(player.index)

	local children = {}

	for i = 1, cols * rows do
		children[i] = Slot.new(i, player)
	end

	return Gui.frame({
		name = Const.UI_ID.SLOT_OUTER_FRAME,
		direction = "horizontal",
		style = "quick_bar_inner_panel",
		children = {
			Gui.table({
				name = Const.UI_ID.SLOT_TABLE,
				column_count = cols,
				children = children,
				style = "slot_table",
				style_mods = {
					vertical_spacing = 2,
				},
			}),
		},
	})
end

function SlotTable.render(parent, player)
	Gui.render(parent, SlotTable.new(player))
end

return SlotTable
