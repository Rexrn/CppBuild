local _print_c = require("../thirdparty/chroma")
local ConsoleApplication = require "ConsoleApplication"

_print_c.print = function(s) return io.write(s) end


local function print_c(s, ...)
	s = string.format(s, ...)

	local colors = {
			["red"] 	= "red",
			["green"] 	= "green",
			["blue"] 	= "blue",
			["yellow"] 	= "yellow",
			["orange"] 	= "orange",
			["white"] 	= "white",
			["gray"]	= "gray",
			["purple"] 	= "purple",
			["pink"] 	= "pink",
			["b"] 		= "bold",
			["h"] 		= "highlight",
			["u"] 		= "underline",
			["none"]	= false,
			["n"]		= false
		}
	local currentColor = nil

	function splitStringByDot(str)
		local arr = {}
		for sub in string.gmatch(str, '([^.]+)') do
			table.insert(arr, sub)
		end
		return arr
	end

	function printPart(str)
		local printFunc = _print_c

		-- Should apply modifiers?
		if currentColor ~= nil then
			local mods 		= splitStringByDot(currentColor)
			-- Go down the chain (iterate through next modifiers)
			for index, value in ipairs(mods) do
				if colors[value] == false then
					printFunc = _print_c
					break
				end
				printFunc = printFunc[colors[value]]
			end
		end

		printFunc(str)
	end

	-- Detect whether modifier sequence is valid
	-- For example: "b.green" is bold and green
	function isValidModifierSequence(mods)
		for index, value in ipairs(mods) do
			if colors[value] == nil then
				return false
			end
		end
		return true
	end

	function findFirstColor(str)

		local result 	= { pos = nil, key = nil }
		local pos 		= 0
		local proceed 	= true

		while proceed do
			proceed = false

			-- Find "{something}" sequence
			local startPos = string.find(s, "{", pos)
			if startPos ~= nil then
				local endPos = string.find(s, "}", startPos)
				if endPos ~= nil then

					-- Extract key from "{key}"
					local key = string.sub(s, startPos + 1, endPos - 1)
					-- Allow to search for next
					proceed = true
					pos 	= endPos + 1

					local mods 		= splitStringByDot(key)
					local validSeq 	= isValidModifierSequence(mods)
					
					if validSeq and (result.pos == nil or pos < result.pos) then
						result.pos 	= startPos
						result.key 	= key
						result.mods = mods
					end
				end
			end
		end
		return result
	end

	local proceed = true
	while proceed do
		proceed = false

		local f = findFirstColor(s)
		if f.pos ~= nil then
			local before = string.sub(s, 0, f.pos - 1)
			printPart(before)

			if #f.mods > 1 or colors[f.key] ~= nil then
				currentColor = f.key
			else
				currentColor = nil
			end

			s = string.sub(s, f.pos + string.len(f.key) + 2)
			proceed = true
		end
	end
	printPart(s)

	return true
end

return print_c;