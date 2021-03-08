CppPackage = {}
function CppPackage.new(id, root)

	local self = {}

	-- Public fields
	
	-- Private fields:
	local _id 		= id
	local _root 	= root
	local _parent 	= nil
	
	if type(_root) ~= "string" then
		_parent 	= _root
		_root 		= nil
	end
	
	-- Public functions
	function self.id()
		return _id
	end

	function self.root()
		if _root ~= nil then
			return _root
		else
			return _parent.root()
		end
	end

	function self.reload()
		local pkgPath = path.join(self.root(), "package.lua")
		local result = dofile(pkgPath)
		if type(result) ~= "table" then
			error(string.format("Could not load package \"%s\": script execution must result in a table, but %s given.", _id, type(result)))
		end
		
		self.cfg = result
	end

	function self.ensureLoaded()
		if self.cfg == nil then
			self.reload()
		end	
	end

	function self.rel(dir)
		return path.join(self.root(), dir)
	end

	function self.sub(name)
		self.ensureLoaded()

		local subPkg = CppPackage.new(name, self)
		subPkg.cfg = self.cfg[name]
		return subPkg
	end

	return self
end

return CppPackage