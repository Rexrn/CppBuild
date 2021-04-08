local CppPackage = require("CppPackage")

PackageManager = {}

function PackageManager.new()

	local self = {
		packages = {},

		error = {
			packageNotFound = function(pkgName)
				print(debug.traceback())
				error(string.format("Could not load package \"%s\"", pkgName))
			end
		}
	}

	function self.get(pkgName)
		return self.packages[pkgName]
	end
	
	-- Composes path that depends on platform configuration.
	-- Example usage (for library containing Bin/x86/Debug/LibFileName)
	--
	-- platformDir("Bin", "LibFileName")
	function self.platformDir(dir, rest)
		return dir .. "/%{cfg.platform}/%{cfg.buildcfg}/" .. rest
	end

	function self.load(pkgName, pkgPath)
		function performLoad(pn, pp)
			if self.packages[pn] == nil then
				-- userConfig.deps[pn].root
				local pkg = CppPackage.new(pn, pp)
				pkg.ensureLoaded()
				self.packages[pn] = pkg
			end
		end

		if type(pkgName) == "string" then
			performLoad(pkgName, pkgPath)
		elseif type(pkgName) == "table" then
			for k, v in pairs(pkgName) do
				performLoad(k, v)
			end
		end
	end

	function self.pkgDir(pkgName, dir)
		local pkg = self.packages[pkgName]
		if pkg ~= nil then
			if dir ~= nil then
				return pkg.rel(dir)
			else
				return pkg.root()
			end
		else
			self.error.packageNotFound(pkgName)
		end
	end
	
	function self.pkgPlatformDir(pkgName, dir, rest)
		return self.pkgDir(pkgName, self.platformDir(dir, rest))
	end
	
	function self.performInclude(pkg, inc)
		includedirs(pkg.rel(inc))
		-- print("Including: \"" .. self.pkgDir(pkgName, inc) .. "\"")
	end

	function self.performLink(pkg, lib)
		links(pkg.rel(lib))
		-- print("Linking: \"" .. self.pkgDir(pkgName, lib) .. "\"")
	end

	function self.findPackage(pkgName, subPkg)
		if self.packages[pkgName] == nil then
			self.error.packageNotFound(pkgName)
		end
		
		local pkg = self.packages[pkgName].cfg

		if subPkg ~= nil then
			if pkg[subPkg] ~= nil then
				pkg = pkg[subPkg]
			else
				self.error.packageNotFound(pkgName .. subPkg)
			end
		end

		return pkg
	end

	-- Deprecated
	function self.forEachPackagePropDo(whatToDo, propName, pkg)

		if type(pkg.cfg[propName]) == "string" then
			whatToDo(pkg, pkg.cfg[propName])
		elseif type(pkg.cfg[propName]) == "table" then
			for _, propValue in ipairs(pkg.cfg[propName]) do
				whatToDo(pkg, propValue)
			end
		else
			error("Invalid type of \"" .. pkg.id() .. ".inc\" - " .. type(pkg.cfg[propName]) .. ".")
		end
	end

	function self.forEachPackageSubPropDo(whatToDo, propName, subPropName, pkg)
		local prop = pkg.cfg[propName]
		if prop ~= nil then
			local subProp = prop[subPropName]
			if subProp ~= nil then
				if type(subProp) == "string" then
					whatToDo(pkg, subProp)
				elseif type(subProp) == "table" then
					for _, propValue in ipairs(subProp) do
						whatToDo(pkg, propValue)
					end
				else
					error(string.format("Invalid type of \"%s.%s.%s\" - %s", pkg.id(), propName, subPropName, type(subProp)))
				end
			end
		end
	end

	-- Deprecated
	function self.handlePackagesProp(whatToDo, propName, pkgs)
		for _, p in ipairs(pkgs) do
			self.forEachPackagePropDo(whatToDo, propName, p)
		end
	end

	function self.handlePackagesSubProp(whatToDo, propName, subPropName, pkgs)
		for _, p in ipairs(pkgs) do
			self.forEachPackageSubPropDo(whatToDo, propName, subPropName, p)
		end
	end
	
	function parsePackages(pkgs)
		local v = {}
		for _, value in ipairs(pkgs) do
			local toAdd
			local pkgName = ""
			if type(value) == "table" then
				toAdd = self.get(value[1]).sub(value[2])
				pkgName = value[1] .. "." .. value[2]
			else
				toAdd = self.get(value)
				pkgName = value
			end
			-- printf("===== Adding %s =====", pkgName)
			table.insert(v, toAdd)
		end
		return v
	end

	-- Deprecated
	function self.include(...)
		self.handlePackagesProp(self.performInclude, "inc", parsePackages(table.pack(...)))
	end
	
	--  Deprecated
	function self.link(...)
		self.handlePackagesProp(self.performLink, "link", parsePackages(table.pack(...)))
	end

	--  Deprecated
	function self.includeDirect(...)
		self.handlePackagesProp(self.performInclude, "inc", table.pack(...))
	end
	
	-- Deprecated
	function self.linkDirect(...)
		self.handlePackagesProp(self.performLink, "link", table.pack(...))
	end

	function self.includeDirectNew(...)
		printf("xd")
		self.handlePackagesSubProp(self.performInclude, "includeDirectories", "interface", table.pack(...))
		printf("xd2")
		self.handlePackagesSubProp(self.performInclude, "includeDirectories", "public", table.pack(...))
		printf("xd3")
	end
	
	function self.linkSingle(pkg)
		local pkgName = pkg.cfg.name
		local pkgType = pkg.cfg.type

		if 	pkgType == "static library" or
			pkgType == "shared library" then

			print("---- Linking: \"" .. pkg.platformDir("bin", pkgName) .. "\"")
			links(pkg.platformDir("bin", pkgName))

		end
	end

	function self.linkDirectNew(...)

		-- self.handlePackagesProp(self.performLink, "linkedLibraries", table.pack(...))
	end



	return self
end

return PackageManager