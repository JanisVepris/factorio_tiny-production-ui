local Gui = require("src.gui")
local Const = require("src.constants")
local SlotTable = require("src.ui.components.slot_table")
local ActionButtons = require("src.ui.components.action_buttons")
local Slot = require("src.ui.components.slot")
local TitleBar = require("src.ui.components.title_bar")
local snitch = require("src.util.snitch")
local state = require("src.state")

local MainWindow = {}

function MainWindow.toggle(player)
	local _, existing = Gui.getMainWindow(player)

	if existing then
		snitch("Toggle main window off")
		local location = existing.location
		state.get(player.index).window_location = { x = location.x, y = location.y }
		existing.destroy()

		return
	end

	snitch("Toggle main window on")
	local location = state.get(player.index).window_location
	local outer = Gui.render(
		player.gui.screen,
		Gui.frame({
			name = Const.UI_ID.MAIN_WINDOW_OUTER,
			direction = state.getOrientation(player.index),
			style_mods = {
				padding = 0,
			},
			children = {
				TitleBar.new(player),
				Gui.flow({
					name = Const.UI_ID.MAIN_WINDOW,
					direction = state.getOrientation(player.index),
					size = { 385, 165 },

					style_mods = {
						padding = 3,
					},

					children = {
						ActionButtons.new(player),
						SlotTable.new(player),
					},
				}),
			},
		})
	)
	if location then
		outer.location = location
	else
		outer.force_auto_center()
	end
	TitleBar.setDragTarget(outer[Const.UI_ID.TITLE_BAR_CONTAINER], outer)
end

function MainWindow.refresh(player)
	local _, window = Gui.getMainWindow(player)
	if not window then
		return
	end

	MainWindow.toggle(player)
	MainWindow.toggle(player)
	MainWindow.updateSlots(player)
end

function MainWindow.updateActionButtonsVisibility(player)
	local window, outer = Gui.getMainWindow(player)
	if not window then
		return
	end
	window[Const.UI_ID.ACTION_BTN_CONTAINER].visible = state.areActionButtonsVisible(player.index)
	TitleBar.update(outer[Const.UI_ID.TITLE_BAR_CONTAINER], player)
end

function MainWindow.updateSlots(player)
	local window = Gui.getMainWindow(player)
	if not window then
		return
	end

	local outer_frame = window[Const.UI_ID.SLOT_OUTER_FRAME]
	if not outer_frame then
		return
	end

	local slot_table = outer_frame[Const.UI_ID.SLOT_TABLE]
	if not slot_table then
		return
	end

	for _, slot in ipairs(slot_table.children) do
		Slot.update(slot, player)
	end
end

function MainWindow.refreshActionButtons(player)
	snitch("Refreshing action buttons")
	local window = Gui.getMainWindow(player)
	if not window then
		return
	end

	local buttons = window[Const.UI_ID.ACTION_BTN_CONTAINER]
	if buttons then
		ActionButtons.update(buttons, player)
	end
end

function MainWindow.refreshSlotTable(player)
	snitch("Refreshing slot table")
	local window = Gui.getMainWindow(player)
	if not window then
		return
	end

	local outer_frame = window[Const.UI_ID.SLOT_OUTER_FRAME]

	if outer_frame then
		outer_frame.destroy()
	end

	SlotTable.render(window, player)
end

return MainWindow
