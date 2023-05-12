tpu.f.production = {}

function tpu.f.production.update_production_rates(player)
    local slot_count = tpu.g.get_slot_count(player)

    for i = 1, slot_count, 1 do
        tpu.f.production.update_production_rate(player, i)
    end
end

function tpu.f.production.update_production_rate(player, index)
    local container = tpu.util.get_slot_container(player)

    if not container then return end

    local slot = container["tpu_slot_" .. index]

    local item_name = slot.elem_value

    if not item_name then
        container["tpu_slot_rate_container_outer_" .. index]["tpu_slot_rate_container_" .. index]["tpu_slot_rate_output_" .. index].caption = ""
        container["tpu_slot_rate_container_outer_" .. index]["tpu_slot_rate_container_" .. index]["tpu_slot_rate_input_" .. index].caption = ""
        return
    end

    local precision = tpu.g.get_rate_precision(player)

    local output_rate = tpu.f.production.get_item_flow_rate(player, item_name, precision).output
    local input_rate = tpu.f.production.get_item_flow_rate(player, item_name, precision).input

    container["tpu_slot_rate_container_outer_" .. index]["tpu_slot_rate_container_" .. index]["tpu_slot_rate_output_" .. index].caption = "+"..tpu.util.format_number(output_rate)
    container["tpu_slot_rate_container_outer_" .. index]["tpu_slot_rate_container_" .. index]["tpu_slot_rate_input_" .. index].caption = "-"..tpu.util.format_number(input_rate)
end

function tpu.f.production.get_item_flow_rate(player, item, precision)
    local rate_output = player.force.item_production_statistics.get_flow_count{
        name = item,
        input = true,
        precision_index = precision,
        count = true
    }

    local rate_input = player.force.item_production_statistics.get_flow_count{
        name = item,
        input = false,
        precision_index = precision,
        count = true
    }

    return {
        input = rate_input,
        output = rate_output,
    }
end
