tpu.f.production = {}

function tpu.f.production.update_production_rates(player)
    local slot_count = tpu.g.get_slot_count(player)

    local display_mode = tpu.g.get_display_mode(player)

    for i = 1, slot_count, 1 do
        if display_mode == tpu.defines.gui.display_mode.totals then
            tpu.f.production.update_production_totals(player, i)
        end

        if display_mode == tpu.defines.gui.display_mode.diff then
            tpu.f.production.update_production_diffs(player, i)
        end
    end
end

function tpu.f.production.update_production_totals(player, index)
    local container = tpu.util.get_slot_container(player)

    if not container then return end

    local slot_label_container = tpu.util.get_slot_label_container(player, index)

    if not slot_label_container then return end

    local slot = container["tpu_slot_" .. index]

    local item_name = slot.elem_value

    if not item_name then
        slot_label_container["tpu_slot_rate_output_" .. index].caption = ""
        slot_label_container["tpu_slot_rate_input_" .. index].caption = ""
        return
    end

    local precision = tpu.g.get_rate_precision(player)

    local output_rate = tpu.f.production.get_item_flow_rate(player, item_name, precision).output
    local input_rate = tpu.f.production.get_item_flow_rate(player, item_name, precision).input

    slot_label_container["tpu_slot_rate_output_" .. index].caption = "+"..tpu.util.format_number(output_rate)
    slot_label_container["tpu_slot_rate_input_" .. index].caption = "-"..tpu.util.format_number(input_rate)
end

function tpu.f.production.update_production_diffs(player, index)
    local container = tpu.util.get_slot_container(player)

    if not container then return end

    local slot_label_container = tpu.util.get_slot_label_container(player, index)

    if not slot_label_container then return end

    local slot = container["tpu_slot_" .. index]

    local item_name = slot.elem_value

    if not item_name then
        slot_label_container["tpu_slot_rate_difference_" .. index].caption = ""
        return
    end

    local precision = tpu.g.get_rate_precision(player)

    local output_rate = tpu.f.production.get_item_flow_rate(player, item_name, precision).output
    local input_rate = tpu.f.production.get_item_flow_rate(player, item_name, precision).input

    local difference = output_rate - input_rate

    local prefix = "+"
    local font_color = {r = 0.3, g = 1, b = 0.3}

    if difference < 0 then
        prefix = ""
        font_color = {r = 1, g = 0.3, b = 0.3}
    end

    slot_label_container["tpu_slot_rate_difference_" .. index].caption = prefix .. tpu.util.format_number(difference)
    slot_label_container["tpu_slot_rate_difference_" .. index].style.font_color = font_color
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
