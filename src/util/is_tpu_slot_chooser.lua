local Const = require("src.constants")
local function is_tpu_slot_chooser(name)
	local prefix = Const.UI_ID.SLOT_CHOOSER

	return name:sub(1, #prefix) == prefix
end

return is_tpu_slot_chooser
