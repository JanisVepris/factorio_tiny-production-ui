local Const = require("src.constants")

local Gui = {}

local handlers = {}

---@param player LuaPlayer
---@return LuaGuiElement? window Inner content flow.
---@return LuaGuiElement? outer Screen-level frame.
function Gui.getMainWindow(player)
	local outer = player.gui.screen[Const.UI_ID.MAIN_WINDOW_OUTER]
	if not outer or not outer.valid then
		return nil, nil
	end

	local window = outer[Const.UI_ID.MAIN_WINDOW]
	if not window or not window.valid then
		return nil, outer
	end

	return window, outer
end

function Gui.init()
	-- Dispatch UI events
	script.on_event(defines.events.on_gui_click, function(event)
		Gui.dispatch(event)
	end)
end

function Gui.register(name, callback)
	assert(not handlers[name], "Duplicate handler: " .. name)
	handlers[name] = callback
end

function Gui.dispatch(event)
	if not event.element or not event.element.valid then
		return
	end

	local tags = event.element.tags
	local action = tags.action

	if not action then
		return
	end

	local handler = handlers[action]

	if handler then
		handler(event)
	end
end

function Gui.render(parent, definition)
	local children = definition.children

	local props = {}

	for key, value in pairs(definition) do
		if key ~= "children" and key ~= "onClick" and key ~= "style_mods" then
			props[key] = value
		end
	end

	if definition.onClick then
		props.tags = props.tags or {}
		props.tags.action = definition.onClick
	end

	local element = parent.add(props)

	for key, value in pairs(definition.style_mods or {}) do
		element.style[key] = value
	end

	for _, child in ipairs(children or {}) do
		Gui.render(element, child)
	end

	return element
end

function Gui.emptyWidget(props)
	props.type = "empty-widget"
	return props
end


function Gui.label(props)
	props.type = "label"
	return props
end

function Gui.frame(props)
	props.type = "frame"
	return props
end

function Gui.flow(props)
	props.type = "flow"
	return props
end

function Gui.table(props)
	props.type = "table"
	return props
end

function Gui.spriteButton(props)
	props.type = "sprite-button"
	return props
end

function Gui.elemChooser(props)
	props.type = "choose-elem-button"
	return props
end

function Gui.switch(props)
	props.type = "switch"
	return props
end

return Gui
