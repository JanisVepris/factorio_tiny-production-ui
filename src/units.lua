local Units = {}

-- Add units here in cycling order. A divisor expresses items per display unit.
local definitions = {
	{
		id = "items",
		name = { "tpu.unit-items" },
		sprite = "tpu_unit_items",
		divisor = function(item) return 1 end,
	},
	{
		id = "stacks",
		name = { "tpu.unit-stacks" },
		sprite = "tpu_unit_stacks",
		divisor = function(item) return prototypes.item[item].stack_size end,
	},
}

function Units.get(id)
	for _, unit in ipairs(definitions) do
		if unit.id == id then
			return unit
		end
	end
	return definitions[1]
end

function Units.next(id)
	for index, unit in ipairs(definitions) do
		if unit.id == id then
			return definitions[index % #definitions + 1].id
		end
	end
	return definitions[1].id
end

function Units.convert(production, consumption, item, id)
	local divisor = Units.get(id).divisor(item)
	local produced = production / divisor
	local consumed = consumption / divisor
	return produced, consumed, produced - consumed
end

return Units
