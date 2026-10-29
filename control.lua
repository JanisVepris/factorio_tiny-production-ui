local Gui = require("src.gui")
local GuiEvents = require("src.gui_events")
local State = require("src.state")
local Const = require("src.constants")
local MainWindow = require("src.ui.main_window")

---@diagnostic disable-next-line
if Const.DEBUG and script.active_mods["gvv"] then
	---@diagnostic disable-next-line
	require("__gvv__.gvv")()
end

script.on_init(function()
	State.init()
end)

script.on_configuration_changed(function()
	State.init()
	MainWindow.rebuildAll()
end)

GuiEvents.init()
Gui.init()
