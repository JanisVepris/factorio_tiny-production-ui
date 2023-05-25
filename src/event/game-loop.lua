tpu.e.loop = {}
tpu.e.loop.handler = {}

function tpu.e.loop.handler.on_init()
    tpu.util.debug("INIT EVENT START")

    if not global.tpu_tpu then global.tpu_tpu = {} end

    for _, player in pairs(game.players) do
        tpu.gui.initialize_player_gui(player)
    end

    tpu.util.debug("INIT EVENT END", true)
end

function tpu.e.loop.handler.on_config_change(event)
    tpu.util.debug("CONFIG CHANGED EVENT START")
    tpu.util.debug(event)

    if not global.tpu_tpu then global.tpu_tpu = {} end

    local setting_prefix = string.sub(event.setting, 1, 4)

    if setting_prefix ~= "tpu-" then
        tpu.util.debug("Irrelevant setting, skipping", true)
        return
    end

    local player = game.get_player(event.player_index)

    local isTpuEnabled = tpu.util.pcfg(player, "tpu-enabled")

    if not isTpuEnabled then tpu.gui.destroy_gui(player) end

    tpu.gui.refresh_gui(player)

    tpu.util.debug("CONFIG CHANGED EVENT END", true)
end

function tpu.e.loop.handler.on_player_created(event)
    tpu.util.debug("PLAYER CREATED EVENT START")
    tpu.util.debug(event)

    if not global.tpu_tpu then global.tpu_tpu = {} end

    local player = game.get_player(event.player_index)

    tpu.gui.initialize_player_gui(player)

    player.print({ "tpu.print-init" })

    tpu.util.debug("PLAYER CREATED EVENT END", true)
end

function tpu.e.loop.handler.on_tick()
    if not global.tpu_tpu then global.tpu_tpu = {} end

    tpu.util.debug("TICK EVENT START")

    for _, player in pairs(game.players) do

        local version = tpu.g.get_version(player)

        if version ~= tpu.version then
            tpu.util.debug("Tick event for player: " .. player.name)
            tpu.gui.refresh_gui(player)
            tpu.g.set_version(player, tpu.version)
        end

    end

    tpu.util.debug("TICK EVENT END", true)
end

function tpu.e.loop.handler.on_nth_tick(event)
    for _, player in pairs(game.players) do
        if not tpu.util.pcfg(player, "tpu-enabled") then return end

        tpu.f.production.update_production_rates(player)
    end
end

function tpu.e.loop.init()
    tpu.util.debug("Init event loop")

    script.on_init(tpu.e.loop.handler.on_init)
    script.on_event(defines.events.on_player_created, tpu.e.loop.handler.on_player_created)
    script.on_event(defines.events.on_runtime_mod_setting_changed, tpu.e.loop.handler.on_config_change)
    script.on_nth_tick(10, tpu.e.loop.handler.on_tick)

    script.on_nth_tick(60, tpu.e.loop.handler.on_nth_tick)

    tpu.util.debug("Init event loop: DONE", true)
end
