local Const = require("src.constants")

local function snitch(input)
	if not Const.DEBUG then
		return
	end

	log("[TPU DBG]: " .. serpent.block(input, { comment = false, numformat = "%1.8g" }))
	log("[TPU DBG]: ##################################")
end

return snitch
