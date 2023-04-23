function tpu.g.get_global(player)
    if not global.tpu_tpu[player.name] then global.tpu_tpu[player.name] = {} end
    return global.tpu_tpu[player.name]
end

function tpu.g.get_gui_orientation(player)
    local global = tpu.g.get_global(player)

    if not global['gui_orientation'] then global['gui_orientation'] = tpu.global_defaults.gui_orientation end

    return global['gui_orientation']
end

function tpu.g.set_gui_orientation(player, orientation)
    local global = tpu.g.get_global(player)

    global['gui_orientation'] = orientation
end

function tpu.g.get_slot_count(player)
    local global = tpu.g.get_global(player)

    if not global['slot_count'] then global['slot_count'] = tpu.global_defaults.slot_count end

    return global['slot_count']
end

function tpu.g.set_slot_count(player, slot_count)
    local global = tpu.g.get_global(player)

    global['slot_count'] = slot_count
end

function tpu.g.get_rate_precision(player)
    local global = tpu.g.get_global(player)

    if not global['rate_precision'] then global['rate_precision'] = tpu.global_defaults.rate_precision end

    return global['rate_precision']
end

function tpu.g.set_rate_precision(player, precision)
    local global = tpu.g.get_global(player)

    global['rate_precision'] = precision
end

function tpu.g.toggle_rate_precision(player)
    local current_rate_precision = tpu.g.get_rate_precision(player)
    local new_rate_precision = current_rate_precision

    if current_rate_precision == defines.flow_precision_index.five_seconds then
        new_rate_precision = defines.flow_precision_index.one_minute
    elseif current_rate_precision == defines.flow_precision_index.one_minute then
        new_rate_precision = defines.flow_precision_index.ten_minutes
    elseif current_rate_precision == defines.flow_precision_index.ten_minutes then
        new_rate_precision = defines.flow_precision_index.one_hour
    elseif current_rate_precision == defines.flow_precision_index.one_hour then
        new_rate_precision = defines.flow_precision_index.ten_hours
    elseif current_rate_precision == defines.flow_precision_index.ten_hours then
        new_rate_precision = defines.flow_precision_index.five_seconds
    end

    tpu.g.set_rate_precision(player, new_rate_precision)
    tpu.util.set_precision_string(player, new_rate_precision)
end
