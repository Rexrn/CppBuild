local class = require("middleclass")

local Project = require("Project")

local StaticLibrary = class("StaticLibrary", Project)

function StaticLibrary:initialize(name)
	Project.initialize(self, name)
	self._kind = "StaticLib"
end

return StaticLibrary