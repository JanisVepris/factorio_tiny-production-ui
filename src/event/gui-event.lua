tpu.e.gui = {}
tpu.e.gui.handler = {}

function tpu.e.gui.is_supported_element(element)
    local prefix = string.sub(element.name, 1, 3)

    if (element.mod == MODNAME) then return true end
    if (prefix == "tpu") then return true end

    return false
end

function tpu.e.gui.is_slot_table_switch(element)
    if element.name == "tpu_ui_slot_table_switch" then return true end

    return false
end

function tpu.e.gui.is_orientation_switch(element)
    if element.name == "tpu_ui_orientation_switch" then return true end

    return false
end

function tpu.e.gui.is_inc_slots_button(element)
    if element.name == "tpu_ui_inc_slots_button" then return true end

    return false
end

function tpu.e.gui.is_dec_slots_button(element)
    if element.name == "tpu_ui_dec_slots_button" then return true end

    return false
end

function tpu.e.gui.is_display_mode_toggle_button(element)
    if element.name == "tpu_display_mode_toggle_button" then return true end

    return false
end

function tpu.e.gui.is_toggle_precision_button(element)
    return element.name == "tpu_ui_toggle_precision_button"
end

function tpu.e.gui.handler.on_slot_table_switch_clicked(event)
    local player = game.get_player(event.player_index)
    local slot_container = tpu.util.get_slot_container(player)

    slot_container.visible = not slot_container.visible
end

function tpu.e.gui.handler.on_orientation_switch_clicked(event)
    local player = game.get_player(event.player_index)

    local current_orientation = tpu.g.get_gui_orientation(player)

    if current_orientation == tpu.defines.gui.orientation.horizontal then
        tpu.g.set_gui_orientation(player, tpu.defines.gui.orientation.vertical)
    else
        tpu.g.set_gui_orientation(player, tpu.defines.gui.orientation.horizontal)
    end

    tpu.gui.refresh_gui(player)
end

function tpu.e.gui.handler.on_inc_slots_button_clicked(event)
    local player = game.get_player(event.player_index)

    local current_slot_count = tpu.g.get_slot_count(player)

    local new_slot_count = current_slot_count + 1

    if new_slot_count > tpu.defines.max_slot_count then return end

    tpu.g.set_slot_count(player, new_slot_count)

    tpu.gui.refresh_gui(player)
end

function tpu.e.gui.handler.on_dec_slots_button_clicked(event)
    local player = game.get_player(event.player_index)

    local current_slot_count = tpu.g.get_slot_count(player)

    local new_slot_count = current_slot_count - 1

    if new_slot_count < tpu.defines.min_slot_count then return end

    tpu.g.set_slot_count(player, new_slot_count)

    tpu.gui.refresh_gui(player)
end

function tpu.e.gui.handler.on_toggle_precision_button_clicked(event)
    local player = game.get_player(event.player_index)

    tpu.g.toggle_rate_precision(player)
end

function tpu.e.gui.handler.on_toggle_display_mode_button_clicked(event)
    local player = game.get_player(event.player_index)

    tpu.g.toggle_display_mode(player)

    tpu.gui.refresh_gui(player)
end

function tpu.e.gui.handler.on_gui_click(event)
    local element = event.element

    if not tpu.e.gui.is_supported_element(element) then return end

    if tpu.e.gui.is_slot_table_switch(element) then
        tpu.e.gui.handler.on_slot_table_switch_clicked(event)
        return
    end

    if tpu.e.gui.is_orientation_switch(element) then
        tpu.e.gui.handler.on_orientation_switch_clicked(event)
        return
    end

    if tpu.e.gui.is_inc_slots_button(element) then
        tpu.e.gui.handler.on_inc_slots_button_clicked(event)
        return
    end

    if tpu.e.gui.is_dec_slots_button(element) then
        tpu.e.gui.handler.on_dec_slots_button_clicked(event)
        return
    end

    if tpu.e.gui.is_toggle_precision_button(element) then
        tpu.e.gui.handler.on_toggle_precision_button_clicked(event)
        return
    end

    if tpu.e.gui.is_display_mode_toggle_button(element) then
        tpu.e.gui.handler.on_toggle_display_mode_button_clicked(event)
        return
    end
end

function tpu.e.gui.init()
    script.on_event(defines.events.on_gui_click, tpu.e.gui.handler.on_gui_click)
end
