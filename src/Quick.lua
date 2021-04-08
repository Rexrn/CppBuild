local Project 			= require("Project")
local Workspace 		= require("Workspace")
local util 				= require("Utility")
local parseTargetConfig = require("TargetConfig")
local print_c			= require("./IO")

Quick = {
	
}

function Quick.defaultWorkspace(wksName)
	local wks = Workspace.new(wksName)
	wks.onInit = function()
		util.initWorkspace()
	end
	return wks
end

-- Creates default workspace and adds project into it.
-- Evaluates workspace at the end.
function Quick.project(p, wks)

	local hadToCreateWks = false

	-- Create workspace if not manually created
	if wks == nil then
		hadToCreateWks = true

		wks = Quick.defaultWorkspace(p.name)
	end	

	wks.add(parseTargetConfig(p))
	
	if hadToCreateWks then
		wks.evaluate()
	end
	return wks
end

-- Creates default workspace and adds projects into it.
-- Evaluates workspace at the end.
function Quick.multiproject(wksName, projects)
	local wks = Quick.defaultWorkspace(wksName)

	for key, value in pairs(projects) do
		if key ~= "name" then
			if value.name == nil then
				value.name = key
			end
			print_c("{b}Loaded project:{green} %s\n", value.name )
			Quick.project(value, wks)
		end
	end

	wks.evaluate()
	return wks
end

function Quick.autodetect(target)

	if target.type == nil then

		print_c("{b}CppBuild Autodetect:{n} Multi-Project Mode\n")

		return Quick.multiproject(target.name, target)

	elseif target.type == "workspace" then

		print_c("{b}CppBuild Autodetect:{n} Workspace Mode\n")
		target.evaluate()
		return target

	else

		print_c("{b}CppBuild Autodetect:{n} Project Mode\n")
		return Quick.project(target)

	end

end


return Quick