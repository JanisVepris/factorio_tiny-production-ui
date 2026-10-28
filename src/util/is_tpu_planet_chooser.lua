local Const = require("src.constants")

local function is_tpu_planet_chooser(name)
	local prefix = Const.UI_ID.BTN_PLANET_SELECTOR

	return name:sub(1, #prefix) == prefix
end

return is_tpu_planet_chooser
