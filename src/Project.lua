local class 	= require("middleclass")
local util 		= require("Utility")

local Project = class("Project")

function Project:initialize(name)
	self._name = name
	self._kind = "ConsoleApp"

	-- Public:
	self.cppStandard 	= "C++17"
	self.language 		= "C++"
end

function Project:getName()
	return self._name
end

function Project:evaluate()
	project(self:getName())
	
	-- Setup base directory:
		local bd = os.getcwd()
		if self.baseDirectory ~= nil then
			bd = self.baseDirectory
		end
		basedir(bd)
		os.chdir(bd);

	kind(self._kind)
	location (path.join(os.getcwd(), "build/%{prj.name}"))

	-- Pre-configure:
	if self.onInit ~= nil then
		self.onInit(self)
	end

	-- Configurable values:
	language(self.language)
	cppdialect(self.cppStandard)
	

	if self.pch ~= nil then
		util.configurePCH(self.pch.header, self.pch.source, self.pch.macro)
	end

	if self.files ~= nil then
		files(self.files)
	end

	if util.gen.isVisualStudio() and self.exportSymbolsFile ~= nil then
		util.exportSymbols(self.exportSymbolsFile)
	end
end

return Project