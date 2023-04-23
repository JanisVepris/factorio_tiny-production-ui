function tpu.gui.add_gui_layout(player)

    tpu.util.debug("Add GUI layout")

    local gui = tpu.util.get_gui_base(player)
    local orientation = tpu.g.get_gui_orientation(player)

    local frame = gui.add {
        type = "frame",
        name = "tpu_ui_frame_outer",
        direction = "vertical",
        style = "quick_bar_window_frame"
    }

    local titlebar = frame.add{
        type = "flow",
        name = "tpu_ui_titlebar",
        direction = tpu.g.get_gui_orientation(player),
    }

    titlebar.drag_target = frame

    local titlebar_flow = titlebar.add{
        type = "flow",
        name = "tpu_ui_titlebar_flow",
        direction = "horizontal",
        ignored_by_interaction = true,
    }

    titlebar_flow.add{
        type = "label",
        name = "tpu_ui_titlebar_label",
        style = "caption_label",
        caption = {"tpu.titlebar"},
        ignored_by_interaction = true,
    }

    titlebar_flow.add{
        type = "label",
        name = "tpu_ui_titlebar_precision",
        caption = "",
        ignored_by_interaction = true,
    }

    local spacer = titlebar.add{
        type = "empty-widget"
    }

    spacer.style.width = 20

    local control_bar = titlebar.add {
        type = "flow",
        direction = "horizontal",
    }

    control_bar.style.bottom_margin = 8

    tpu.gui.add_control_buttons(control_bar, player)

    local frameInner = frame.add{
        type = "frame",
        name = "tpu_ui_frame_inner",
        style = "quick_bar_inner_panel"
    }

    local flow = frameInner.add{
        type = "flow",
        name = "tpu_ui_frame_inner_flow",
        direction = "vertical",
    }

    local column_count = 2

    if orientation == tpu.defines.gui.orientation.horizontal then
        column_count = tpu.g.get_slot_count(player)
    end

    local table = flow.add{
        type = "table",
        name = "tpu_ui_table_inner",
        column_count = column_count,
        draw_vertical_lines = false,
        draw_horizontal_lines = true,
        draw_horizontal_line_after_headers = false,
        style = "slot_table"
    }

    table.style.vertical_spacing = 3

    tpu.util.set_precision_string(player, tpu.g.get_rate_precision(player))

    tpu.util.debug("Add GUI layout: DONE")
end

function tpu.gui.add_control_buttons(control_bar, player)
    local orientation = tpu.g.get_gui_orientation(player)
    local font_color = {r = 1, g = 1, b = 1}

    local table_switch = control_bar.add{
        type = "button",
        name = "tpu_ui_slot_table_switch",
        style = "frame_action_button",
        caption = "⚫",
        tooltip = {"tpu.visibility-toggle-tooltip"}
    }

    table_switch.style.font_color = font_color

    -- local orientation_switch = control_bar.add{
    --     type = "button",
    --     name = "tpu_ui_orientation_switch",
    --     style = "frame_action_button",
    --     tooltip = {"tpu.orientation-switch-tooltip"}
    -- }

    -- orientation_switch.style.font_color = font_color

    -- if orientation == tpu.defines.gui.orientation.horizontal then
    --     orientation_switch.caption = "↔"
    -- elseif orientation == tpu.defines.gui.orientation.vertical then
    --     orientation_switch.caption = "↕"
    -- end

    local inc_slots_button = control_bar.add{
        type = "button",
        name = "tpu_ui_inc_slots_button",
        style = "frame_action_button",
        caption = "+",
        tooltip = {"tpu.inc-slots-button"}
    }

    inc_slots_button.style.font_color = font_color

    local dec_slots_button = control_bar.add{
        type = "button",
        name = "tpu_ui_dec_slots_button",
        style = "frame_action_button",
        caption = "-",
        tooltip = {"tpu.dec-slots-button"}
    }

    dec_slots_button.style.font_color = font_color

    local toggle_precision_button = control_bar.add{
        type = "button",
        name = "tpu_ui_toggle_precision_button",
        style = "frame_action_button",
        caption = "☵",
        tooltip = {"tpu.toggle-time-period-tooltip"},
    }

    toggle_precision_button.style.font_color = font_color
end

function tpu.gui.add_slots(player)
    tpu.util.debug("Adding slots")

    local slot_count = tpu.g.get_slot_count(player)
    local container = tpu.util.get_slot_container(player)

    local elem_filters = {}

    local orientation = tpu.g.get_gui_orientation(player)

    if orientation == tpu.defines.gui.orientation.vertical
    then
        tpu.gui.add_slots_vertical(container, slot_count, elem_filters)
    elseif orientation == tpu.defines.gui.orientation.horizontal
    then
        tpu.gui.add_slots_horizontal(container, slot_count, elem_filters)
    end

    tpu.util.debug("Adding slots: DONE")
end

function tpu.gui.add_slots_horizontal(container, slot_count, elem_filters)
    for i = 1, slot_count, 1
    do
        container.add {
            name = "tpu_slot_" .. i,
            type = "choose-elem-button",
            elem_type = "item",
            style = "quick_bar_slot_button",
            elem_filters = elem_filters,
        }
    end

    for i = 1, slot_count, 1
    do
        container.add {
            type = "label",
            name = "tpu_slot_rate_" .. i,
        }
    end
end

function tpu.gui.add_slots_vertical(container, slot_count, elem_filters)
    for i = 1, slot_count, 1
    do
        local slot_button = container.add {
            name = "tpu_slot_" .. i,
            type = "choose-elem-button",
            elem_type = "item",
            style = "quick_bar_slot_button",
            elem_filters = elem_filters,
        }

        slot_button.style.height = 42
        slot_button.style.width = 42

        local label_container = container.add{
            type="flow",
            name = "tpu_slot_rate_container_" .. i,
            direction = "vertical",
        }

        label_container.style.padding = 0
        label_container.style.vertical_align = "top"
        label_container.style.horizontal_align = "right"

        local output = label_container.add {
            type = "label",
            name = "tpu_slot_rate_output_" .. i,
            tooltip = "tpu.output-caption",
            style = "electric_usage_label",
        }

        local input = label_container.add {
            type = "label",
            name = "tpu_slot_rate_input_" .. i,
            tooltip = "tpu.input-caption",
            style = "electric_usage_label",
        }

        output.style.horizontal_align = "right"
        output.style.vertical_align = "top"
        output.style.padding = 0
        output.style.margin = 0
        output.style.height = 1

        input.style.horizontal_align = "right"
        input.style.vertical_align = "top"
        input.style.padding = 0
        input.style.margin = 0
        input.style.height = 1

        output.style.font_color = {r = 0.3, g = 1, b = 0.3}
        input.style.font_color = {r = 1, g = 0.3, b = 0.3}
    end
end

function tpu.gui.initialize_player_gui(player)
    local isTpuEnabled = tpu.util.pcfg(player, "tpu-enabled")

    if not isTpuEnabled then return end

    tpu.util.debug("Initializing player GUI")

    tpu.gui.add_gui_layout(player)
    tpu.gui.add_slots(player)
end

function tpu.gui.get_selected_recipes(player, solt_container)
    local slot_count = tpu.g.get_slot_count(player)

    local selected_recipes = {}

    for i = 1, slot_count, 1
    do
        local value = nil

        if solt_container["tpu_slot_" .. i] ~= nil then
            value = solt_container["tpu_slot_" .. i].elem_value
        end

        table.insert(selected_recipes, value)
    end

    return selected_recipes
end

function tpu.gui.set_selected_recipes(player, selected_recipes, solt_container)
    local slot_count = tpu.g.get_slot_count(player)

    for i = 1, slot_count, 1
    do
        local recipe = selected_recipes[i]

        if recipe ~= nil then
            solt_container["tpu_slot_" .. i].elem_value = recipe
        end
    end
end

function tpu.gui.destroy_gui(player)
    tpu.util.debug("Destroying player GUI")

    if player.gui.top.tpu_ui_frame_outer ~= nil then
        player.gui.top.tpu_ui_frame_outer.destroy()
    end

    if player.gui.left.tpu_ui_frame_outer ~= nil then
        player.gui.left.tpu_ui_frame_outer.destroy()
    end

    if player.gui.screen.tpu_ui_frame_outer ~= nil then
        player.gui.screen.tpu_ui_frame_outer.destroy()
    end

    if player.gui.center.tpu_ui_frame_outer ~= nil then
        player.gui.center.tpu_ui_frame_outer.destroy()
    end

    if player.gui.goal.tpu_ui_frame_outer ~= nil then
        player.gui.goal.tpu_ui_frame_outer.destroy()
    end

    tpu.util.debug("Destroying player GUI: DONE")
end

function tpu.gui.refresh_gui(player)
    local isTpuEnabled = tpu.util.pcfg(player, "tpu-enabled")

    if not isTpuEnabled then return end

    local slot_container = tpu.util.get_slot_container(player)

    tpu.util.debug("Refreshing GUI")

    local selected_recipes = {}

    if slot_container then
        selected_recipes = tpu.gui.get_selected_recipes(player, slot_container)
    end

    local container_location = {
        x = 50,
        y = 50,
    }

    local slot_container_outer = tpu.util.get_slot_container(player, true)

    if slot_container_outer then
        container_location = slot_container_outer.location
    end

    tpu.gui.destroy_gui(player)

    tpu.gui.initialize_player_gui(player)

    slot_container_outer = tpu.util.get_slot_container(player, true)
    slot_container_outer.location = container_location

    slot_container = tpu.util.get_slot_container(player)

    tpu.gui.set_selected_recipes(player, selected_recipes, slot_container)

    tpu.util.debug("Refreshing GUI: DONE")
end
