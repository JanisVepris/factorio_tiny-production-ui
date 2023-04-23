function tpu.util.set_precision_string(player, precision)
    local container = tpu.util.get_slot_container(player, true)
    local precision_string = ""

    if precision == defines.flow_precision_index.five_seconds then
        precision_string = "5s"
    elseif precision == defines.flow_precision_index.one_minute then
        precision_string = "1m"
    elseif precision == defines.flow_precision_index.ten_minutes then
        precision_string = "10m"
    elseif precision == defines.flow_precision_index.one_hour then
        precision_string = "1h"
    elseif precision == defines.flow_precision_index.ten_hours then
        precision_string = "10h"
    end

    container.tpu_ui_titlebar.tpu_ui_titlebar_flow.tpu_ui_titlebar_precision.caption = precision_string
end
