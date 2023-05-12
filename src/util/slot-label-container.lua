-- get UI slot container element
function tpu.util.get_slot_label_container(player, index)
    local slot_container = tpu.util.get_slot_container(player)

    if not slot_container then return nil end

    local slot_label_container_outer = slot_container["tpu_slot_rate_container_outer_" .. index]

    if not slot_label_container_outer then return nil end
    if not slot_label_container_outer["tpu_slot_rate_container_" .. index] then return nil end

    return slot_label_container_outer["tpu_slot_rate_container_" .. index]
end
