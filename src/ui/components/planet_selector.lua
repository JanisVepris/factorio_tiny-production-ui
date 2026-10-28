local gui = require("src.gui")
local constants = require("src.constants")
local state = require("src.state")
local PlanetSelector = {}

local function tooltip(player)
	local planet = state.getPlanet(player.index)
	local name = planet and { "?", { "space-location-name." .. planet }, planet } or { "tpu.all-planets" }
	return { "tpu.planet-filter", name }
end

function PlanetSelector.new(player)
	local value = state.getPlanet(player.index)

	return gui.elemChooser({
		name = constants.UI_ID.BTN_PLANET_SELECTOR,
		style = "frame_action_button",
		elem_type = "space-location",
		tooltip = tooltip(player),
		["space-location"] = value,

		style_mods = {
			size = { 20, 20 },
		},
	})
end

function PlanetSelector.update(element, player)
	element.elem_value = state.getPlanet(player.index)
	element.tooltip = tooltip(player)
end
return PlanetSelector
