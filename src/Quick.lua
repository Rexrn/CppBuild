local Project 			= require("Project")
local Workspace 		= require("Workspace")
local util 				= require("Utility")
local parseTargetConfig = require("TargetConfig")

Quick = {
	
}

-- Creates default 
function Quick.project(p, wks)

	local hadToCreateWks = false

	-- Create workspace if not manually created
	if wks == nil then
		wks = Workspace.new(p.name)
		hadToCreateWks = true
	end	

	wks.onInit = function()
		util.initWorkspace()
	end

	wks.add(parseTargetConfig(p))
	
	if hadToCreateWks then
		wks.evaluate()
	end
	return wks
end

return Quick