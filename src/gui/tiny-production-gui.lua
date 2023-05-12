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

    local titlebar = tpu.gui.c.titlebar(frame)

    tpu.gui.c.controlBar(titlebar, tpu.g.get_display_mode(player))

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

    -- tpu.gui.c.displayModeButton(flow, tpu.g.get_display_mode(player))

    tpu.util.set_precision_string(player, tpu.g.get_rate_precision(player))

    tpu.util.debug("Add GUI layout: DONE")
end

function tpu.gui.add_slots(player)
    tpu.util.debug("Adding slots")

    local slot_count = tpu.g.get_slot_count(player)
    local container = tpu.util.get_slot_container(player)

    for i = 1, slot_count, 1
    do
        tpu.gui.c.slot(container, "tpu_slot_" .. i)

        local display_mode = tpu.g.get_display_mode(player)

        if display_mode == tpu.defines.gui.display_mode.totals then
            tpu.gui.c.totalsLabels(container, i)
        elseif display_mode == tpu.defines.gui.display_mode.diff then
            tpu.gui.c.differenceLabel(container, i)
        end
    end

    tpu.util.debug("Adding slots: DONE")
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
