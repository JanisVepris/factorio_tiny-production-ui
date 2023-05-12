if not global.tpu_tpu then global.tpu_tpu = {} end

tpu = {
    state = {
        dirty = true
    },
    conf = {
        debug = true,
        log_prefix = "TPU",
        log_format = {
            comment = false,
            numformat = '%1.8g'
        },
    },
    e = {},
    util = {},
    f = {},
    gui = {},
    g = {}, -- global var utils
    global_defaults = {
        gui_orientation = "vertical",
        slot_count = 4,
        rate_precision = defines.flow_precision_index.ten_minutes,
        display_mode = "totals",
    },
    defines = {
        gui ={
            orientation = {
                vertical = "vertical",
                horizontal = "horizontal",
            },
            display_mode = {
                diff = "diff",
                totals = "totals",
            }
        },
        max_slot_count = 15,
        min_slot_count = 1,
        number_format_suffix = {"K","M","B","T","q","Q","s","S","O","N","d","U","D"},
    },
}

-- utils
require("src/util/format-number")
require("src/util/debug")
require("src/util/cfg")
require("src/util/slot-container")
require("src/util/slot-label-container")
require("src/util/gui-base")
require("src/util/precision-string")
require("src/util/global")

-- functions
require("src/function/production.lua")

-- gui
require("src/gui/gui-components")
require("src/gui/tiny-production-gui")

--event
require("src/event/game-loop")
require("src/event/gui-event")

tpu.e.loop.init()
tpu.e.gui.init()
