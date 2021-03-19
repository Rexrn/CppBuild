Workspace = {}

function Workspace.new(name)
	local self = {
		projects = {},
		type = "workspace"
	}

	local _name = name

	function self.name()
		return _name
	end

	function self.evaluateProjects()
		for key,value in pairs(self.projects) do
			value:evaluate()
		end
	end

	function self.evaluate()
		workspace(_name)

		location("build")
		targetdir(path.join(os.getcwd(), "bin/%{cfg.platform}/%{cfg.buildcfg}"))

		if self.onInit ~= nil then
			self.onInit(self)
		end

		self.evaluateProjects()
	end

	function self.add(project)
		table.insert(self.projects, project)
	end

	return self
end

return Workspace