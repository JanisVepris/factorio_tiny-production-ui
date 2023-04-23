-- function tpu.util.format_number(n)
--     local T={"K","M","B","T","q","Q","s","S","O","N","d","U","D"}
--     if not tonumber(n) then return n end

-- 	if n < 10000 then return math.floor(n) end

--     local d = math.floor(math.log(n, 10)/3)*3

--     local s = tostring(n/(10^d)):sub(1,5)

--     return s.." "..tostring(T[math.floor(d/3)])
-- end


function tpu.util.format_number(number)
    if number < 1000 then return tostring(number) end

    local num = 0.0
    local suffix = ""

    if number > 999 and number < 1000000 then
        num = number / 1000.0
        suffix = "K"
    elseif number > 999999 and number < 1000000000 then
        num = number / 1000000.0
        suffix = "M"
    elseif number > 999999999 < 1000000000000 then
        num = number / 1000000000.0
        suffix = "B"
    else
        num = number / 1000000000000.0
        suffix = "T"
    end

    return string.format("%.1f", num) .. suffix
end
