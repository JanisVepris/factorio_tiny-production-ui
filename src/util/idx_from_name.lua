---@param name string
---@return number?
local function idx_from_name(name)
	return tonumber(name:match("_(%d+)$"))
end

return idx_from_name
