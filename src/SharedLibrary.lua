local class = require("middleclass")

local Project = require("Project")

local SharedLibrary = class("SharedLibrary", Project)

function SharedLibrary:initialize(name)
	Project.initialize(self, name)
	self._kind = "SharedLib"
end

return SharedLibrary