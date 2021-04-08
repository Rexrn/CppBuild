local class 			= require("thirdparty/middleclass")
local util 				= require("Utility")
local PackageManager 	= require("PackageManager");

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

	function isArray(arr)
		if type(arr) == "table" and arr[1] ~= nil then
			return true
		end
		return false
	end

	function preparePropWithAccessSpecs(propName)
		if self[propName] ~= nil then
			if isArray(self[propName]) then
				self[propName] = { public = self[propName] }
			end
		end
	end

	preparePropWithAccessSpecs("includeDirectories")
	preparePropWithAccessSpecs("dependsOn")
	preparePropWithAccessSpecs("compileOptions")
	preparePropWithAccessSpecs("linkOptions")

	if self.dependsOn ~= nil then
		for index, value in ipairs(self.dependsOn) do
			print("Importing " .. value.name .. " from " .. value.from )

			Packages.load(value.name, value.from)

			local pkg = Packages.get(value.name).sub(value.name)

			Packages.includeDirectNew(pkg)
			Packages.linkSingle(pkg)
		end
	end

	if self.includeDirectories ~= nil then
		if self.includeDirectories.public ~= nil then
			includedirs(self.includeDirectories.public)
		end
		if self.includeDirectories.private ~= nil then
			includedirs(self.includeDirectories.private)
		end
	end

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