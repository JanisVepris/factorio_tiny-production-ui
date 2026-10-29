local Gui = require("src.gui")
local State = require("src.state")
local Const = require("src.constants")

local AutoHide = {}

local function belongsTo(element, root)
	while element and element.valid do
		if element == root then
			return true
		end
		element = element.parent
	end
	return false
end

function AutoHide.apply(player)
	local window, root = Gui.getMainWindow(player)
	if not window then return end
	local state = State.get(player.index)
	local viewport = root[Const.UI_ID.MAIN_WINDOW_VIEWPORT]
	-- Keep content in the layout along the handle's length. Clip only the
	-- perpendicular axis, so the handle keeps its size without measuring pixels.
	viewport.style = "tpu_content_viewport"
	viewport.style.padding = 0
	viewport.style.margin = 0
	viewport.style.extra_padding_when_activated = 0
	local horizontal = State.getOrientation(player.index) == "horizontal"
	local hidden = State.isAutoHideEnabled(player.index) and state.auto_hide_revealed == false
	-- Allow overflow on the collapsed axis while the other axis keeps the
	-- handle's full length. A maximum of zero means unlimited in Factorio.
	viewport.horizontal_scroll_policy = horizontal and hidden and "dont-show-but-allow-scrolling" or "never"
	viewport.vertical_scroll_policy = not horizontal and hidden and "dont-show-but-allow-scrolling" or "never"
	if hidden then
		viewport.style[horizontal and "horizontally_squashable" or "vertically_squashable"] = true
		-- One pixel exposes only the content flow's three pixels of padding.
		viewport.style[horizontal and "width" or "height"] = 1
	end
end

function AutoHide.reset(player)
	local state = State.get(player.index)
	state.auto_hide_hovered = nil
	state.auto_hide_revealed = true
	state.auto_hide_deadline = State.isAutoHideEnabled(player.index) and game.tick + Const.AUTO_HIDE_DELAY or nil
end

function AutoHide.hover(player, element, tick)
	local root = Gui.getMainWindowRoot(player)
	if not root or not belongsTo(element, root) then return end
	local state = State.get(player.index)
	local was_hidden = state.auto_hide_revealed == false
	state.auto_hide_hovered = element
	state.auto_hide_deadline = nil
	state.auto_hide_revealed = true
	if was_hidden and State.isAutoHideEnabled(player.index) then AutoHide.apply(player) end
end

function AutoHide.leave(player, element, tick)
	local state = State.get(player.index)
	if state.auto_hide_hovered ~= element then return end
	state.auto_hide_hovered = nil
	state.auto_hide_deadline = tick + Const.AUTO_HIDE_DELAY
end

function AutoHide.update(player, tick)
	if not State.isAutoHideEnabled(player.index) then return end
	local state = State.get(player.index)
	local hovered = state.auto_hide_hovered
	if hovered and hovered.valid then return end
	if hovered then
		state.auto_hide_hovered = nil
		state.auto_hide_deadline = tick + Const.AUTO_HIDE_DELAY
	end
	if State.getReorderSource(player.index)
		or (player.opened_gui_type and player.opened_gui_type ~= defines.gui_type.none) then
		state.auto_hide_deadline = tick + Const.AUTO_HIDE_DELAY
		return
	end
	if state.auto_hide_deadline and tick >= state.auto_hide_deadline then
		state.auto_hide_revealed = false
		state.auto_hide_deadline = nil
		AutoHide.apply(player)
	end
end

return AutoHide
