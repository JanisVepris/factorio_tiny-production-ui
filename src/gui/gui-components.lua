tpu.gui.c = {}

function tpu.gui.c.titlebar(container)
    local titlebar = container.add{
        type = "flow",
        name = "tpu_ui_titlebar",
        direction = "vertical",
    }

    titlebar.drag_target = container

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

    local titlebar_gap = titlebar_flow.add {
        type = "empty-widget"
    }

    titlebar_gap.style.horizontally_stretchable = "on"

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

    return titlebar
end

function tpu.gui.c.actionButton(container, name, caption, tooltip)
    local font_color = {r = 1, g = 1, b = 1}

    local button = container.add {
        type = "button",
        name = name,
        style = "frame_action_button",
        caption = caption,
        tooltip = tooltip
    }

    button.style.font_color = font_color
end

function tpu.gui.c.controlBar(container, displayMode)
    local control_bar = container.add {
        type = "flow",
        direction = "horizontal",
    }

    control_bar.style.bottom_margin = 8

    tpu.gui.c.actionButton(control_bar, "tpu_ui_slot_table_switch", "⚫", {"tpu.visibility-toggle-tooltip"})
    tpu.gui.c.actionButton(control_bar, "tpu_ui_inc_slots_button", "+", {"tpu.inc-slots-button"})
    tpu.gui.c.actionButton(control_bar, "tpu_ui_dec_slots_button", "-", {"tpu.dec-slots-button"})
    tpu.gui.c.actionButton(control_bar, "tpu_ui_toggle_precision_button", "☵", {"tpu.toggle-time-period-tooltip"})

    local displayModeButtonTooltip = {"tpu.display-mode-button-label-difference"}
    local displayModeButtonCaption = "◴"

    if displayMode == tpu.defines.gui.display_mode.diff then
        displayModeButtonTooltip = {"tpu.display-mode-button-label-totals"}
        displayModeButtonCaption = "◕"
    end

    tpu.gui.c.actionButton(control_bar, "tpu_display_mode_toggle_button", displayModeButtonCaption, displayModeButtonTooltip)
end

function tpu.gui.c.slot(container, name)
    local slot = container.add {
        name = name,
        type = "choose-elem-button",
        elem_type = "item",
        style = "quick_bar_slot_button",
    }

    slot.style.height = 42
    slot.style.width = 42
end

function tpu.gui.c.slotLabelContainer(container, index)
    local label_container_outer = container.add {
        type="flow",
        name="tpu_slot_rate_container_outer_" .. index,
        direction="horizontal",
    }

    local spacer = label_container_outer.add {
        type="empty-widget"
    }

    spacer.style.horizontally_stretchable = "on"

    local label_container = label_container_outer.add{
        type="flow",
        name = "tpu_slot_rate_container_" .. index,
        direction = "vertical",
    }

    label_container.style.left_padding = 0
    label_container.style.right_padding = 6
    label_container.style.vertical_align = "top"
    label_container.style.horizontal_align = "right"

    return label_container
end

function tpu.gui.c.totalsLabels(container, index)
    local label_container = tpu.gui.c.slotLabelContainer(container, index)

    local output = label_container.add {
        type = "label",
        name = "tpu_slot_rate_output_" .. index,
        tooltip = "tpu.output-caption",
        style = "bold_label",
    }

    local input = label_container.add {
        type = "label",
        name = "tpu_slot_rate_input_" .. index,
        tooltip = "tpu.input-caption",
        style = "bold_label",
    }

    output.style.font_color = {r = 0.3, g = 1, b = 0.3}
    input.style.font_color = {r = 1, g = 0.3, b = 0.3}
end

function tpu.gui.c.differenceLabel(container, index)
    local label_container = tpu.gui.c.slotLabelContainer(container, index)

    label_container.add {
        type = "label",
        name = "tpu_slot_rate_difference_" .. index,
        tooltip = 'tpu.production-consumption-difference',
        style = "bold_label",
    }
end

function tpu.gui.c.displayModeButton(container, displayMode)
    local displayModeButtonCaption = {"tpu.display-mode-button-label-difference"}

    if displayMode == tpu.defines.gui.display_mode.diff then
        displayModeButtonCaption = {"tpu.display-mode-button-label-totals"}
    end

    container.add {
        type = "button",
        name = "tpu_display_mode_toggle_button",
        caption = displayModeButtonCaption,
    }
end
