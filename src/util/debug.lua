function tpu.util.debug(input, separator)
    if tpu.conf.debug == false then return end

    separator = separator or false

    log(tpu.conf.log_prefix .. serpent.block(input, tpu.conf.log_format))

    if separator == true then
        log(tpu.conf.log_prefix .. "----------------------")
    end
end