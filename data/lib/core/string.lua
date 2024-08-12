function formatNumber(amount)
	local formatted = tostring(amount)
	local k

	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
		if k == 0 then
			break
		end
	end
	return formatted
end

function formatNumber(number)
    if type(number) ~= "number" then
        return number
    end

    if number >= 1000000 then
        local kNumber = math.floor(number / 100000) / 10
        return string.format("%.1fKK", kNumber)
    else
        local str = tostring(number)
        local integer, decimal = str:match('([^.]*)%.?(.*)')
        integer = string.gsub(integer, "(%d)(%d%d%d)$", "%1,%2")
        if decimal ~= "" then
            return integer .. "." .. decimal
        else
            return integer
        end
    end
end

function formatGold(amount)
	if amount >= 100000000 then
		return math.floor(amount / 100000000) .. "KKK"
	elseif amount >= 10000000 then
		return math.floor(amount / 1000000) .. "KK"
		elseif amount >= 1000000 then
	return math.floor(amount / 1000000) .. "KK"
		elseif amount >= 1000 then
		return math.floor(amount / 1000) .. "K"
	else
		return math.floor(amount / 1) .. "gps"
	end
end

table.contains = function(array, value)
	for _, targetColumn in pairs(array) do
		if targetColumn == value then
			return true
		end
	end
	return false
end

string.split = function(str, sep)
	local res = {}
	for v in str:gmatch("([^" .. sep .. "]+)") do
		res[#res + 1] = v
	end
	return res
end

string.splitTrimmed = function(str, sep)
	local res = {}
	for v in str:gmatch("([^" .. sep .. "]+)") do
		res[#res + 1] = v:trim()
	end
	return res
end

string.diff = function(diff)
	local format = {
		{'day', diff / 60 / 60 / 24},
		{'hour', diff / 60 / 60 % 24},
		{'minute', diff / 60 % 60},
		{'second', diff % 60}
	}

	local out = {}
	for k, t in ipairs(format) do
		local v = math.floor(t[2])
		if(v > 0) then
			table.insert(out, (k < #format and (#out > 0 and ', ' or '') or ' and ') .. v .. ' ' .. t[1] .. (v ~= 1 and 's' or ''))
		end
	end
	local ret = table.concat(out)
	if ret:len() < 16 and ret:find('second') then
		local a, b = ret:find(' and ')
		ret = ret:sub(b+1)
	end
	return ret
end

string.trim = function(str)
	return str:match'^()%s*$' and '' or str:match'^%s*(.*%S)'
end

string.starts = function(str, substr)
	return string.sub(str, 1, #substr) == substr
end

string.titleCase = function(str)
	return str:gsub("(%a)([%w_']*)", function(first, rest) return first:upper() .. rest:lower() end)
end