local ConsoleApplication 	= require("ConsoleApplication")
local StaticLibrary 		= require("StaticLibrary")
local SharedLibrary 		= require("SharedLibrary")

local function generateTargetByType(targetName, targetType)
	local t = targetType:lower()
	if t == "console application" then
		return ConsoleApplication:new(targetName)
	elseif t == "static library" then
		return StaticLibrary:new(targetName)
	elseif t == "shared library" then
		return SharedLibrary:new(targetName)
	else
		error(string.format("Invalid target type \"%s\"", targetType))
	end
end

local function copyProp(from, to, propName, required)
	if required == nil then
		required = false
	end
	
	if from[propName] ~= nil then
		to[propName] = from[propName]
	elseif required then
		error(string.format("Property \"%s\" is required!", propName))
	end
end

local function parseTargetConfig(targetConfig)
	local target = generateTargetByType(targetConfig.name, targetConfig.type)

	local cp = function(propName, req)
		copyProp(targetConfig, target, propName, req)
	end

	cp("files")
	cp("includeDirectories")
	cp("dependsOn")
	cp("compileOptions")
	cp("linkOptions")
	cp("pch")
	cp("exportSymbolsFile")
	cp("onInit")

	return target
end

return parseTargetConfig;

