local class = require("middleclass")

local Project = require("Project")

local ConsoleApplication = class("ConsoleApplication", Project)

function ConsoleApplication:initialize(name)
	Project.initialize(self, name)
	self._kind = "ConsoleApp"
end

return ConsoleApplication