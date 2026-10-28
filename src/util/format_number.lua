local format_number = function(originalNumber)
	local isNumberNegative = originalNumber < 0

	local number = originalNumber

	if isNumberNegative then
		number = number * -1
	end

	if number < 1000 then
		return string.format("%.2f", number)
	end

	local num = 0.0
	local suffix = ""

	if number > 999 and number < 1000000 then
		num = number / 1000.0
		suffix = "tpu.number-thousand"
	elseif number > 999999 and number < 1000000000 then
		num = number / 1000000.0
		suffix = "tpu.number-million"
	elseif number > 999999999 < 1000000000000 then
		num = number / 1000000000.0
		suffix = "tpu.number-billion"
	elseif number > 999999999999 < 1000000000000000 then
		num = number / 1000000000000.0
		suffix = "tpu.number-trillion"
	else
		num = number / 1000000000000000.0
		suffix = "tpu.number-quadrillion"
	end

	if isNumberNegative then
		num = num * -1
	end

	return { suffix, string.format("%.2f", num) }
end

return format_number
