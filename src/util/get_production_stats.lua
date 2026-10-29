local function surface_stats(player, surface, item_id, rate_precision, slot_type)
	local statistics
	if slot_type == "fluid" then
		statistics = player.force.get_fluid_production_statistics(surface)
	else
		statistics = player.force.get_item_production_statistics(surface)
	end

	local production = statistics.get_flow_count({
		name = item_id,
		category = "input",
		precision_index = rate_precision,
		count = true,
	})

	local consumption = statistics.get_flow_count({
		name = item_id,
		category = "output",
		precision_index = rate_precision,
		count = true,
	})

	return production, consumption, production - consumption
end

---@param player LuaPlayer
---@param item_id string
---@param rate_precision defines.flow_precision_index
---@param planet_name string? Nil includes all existing planet surfaces.
---@param slot_type 'item'|'fluid'|nil Defaults to item.
local function get_production_stats(player, item_id, rate_precision, planet_name, slot_type)
	if planet_name then
		local planet = game.planets[planet_name]
		if planet and planet.surface then
			return surface_stats(player, planet.surface, item_id, rate_precision, slot_type)
		end
		return 0, 0, 0
	end

	local production, consumption = 0, 0
	for _, surface in pairs(game.surfaces) do
		if surface.planet then
			local produced, consumed = surface_stats(player, surface, item_id, rate_precision, slot_type)
			production = production + produced
			consumption = consumption + consumed
		end
	end
	return production, consumption, production - consumption
end

return get_production_stats
