local Project 			= require("Project")
local Workspace 		= require("Workspace")
local util 				= require("Utility")
local parseTargetConfig = require("TargetConfig")

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
			print("Loaded project " .. value.name )
			Quick.project(value, wks)
		end
	end

	wks.evaluate()
	return wks
end

function Quick.autodetect(target)

	if target.type == nil then

		print("CppBuild Autodetect: Multi-Project Mode")

		return Quick.multiproject(target.name, target)

	elseif target.type == "workspace" then

		print("CppBuild Autodetect: Workspace Mode")
		target.evaluate()
		return target

	else

		print("CppBuild Autodetect: Project Mode")
		return Quick.project(target)

	end

end


return Quick