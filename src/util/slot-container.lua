-- get UI slot container element
function tpu.util.get_slot_container(player, outer)
    outer = outer or false

    local gui = tpu.util.get_gui_base(player)

    if gui.tpu_ui_frame_outer == nil then
        return nil
    end

    if outer then
        return gui.tpu_ui_frame_outer
    end

    if gui.tpu_ui_frame_outer.tpu_ui_frame_inner == nil then
        return nil
    end

    return gui.tpu_ui_frame_outer.tpu_ui_frame_inner.tpu_ui_frame_inner_flow.tpu_ui_table_inner or nil
end