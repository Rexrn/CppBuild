local cb = require("CppBuild")

local print_c = require("../IO")

os.chdir(_WORKING_DIR)


-- Require function success:
function requireSuccess(func)
	local status, info = pcall(func)
	if not status then
		printf("\tError: %s", info)
		return false
	end
	return true
end

-- Parse args
function parseArgs()
	if _ACTION == nil then
		error("No action specified.")
		return
	end
end

-- Main function:
function main()
	if not requireSuccess(parseArgs) then
		return false
	end

	-- Initialize global settings:
	Packages = cb.PackageManager.new()

	-- Load package:
	local pkgPath = path.join(_WORKING_DIR, "package")
	local project = require(pkgPath)

	-- Use `CppBuild.Quick` to handle package
	cb.quick.autodetect(project)
end

-- Execute main function:
if not requireSuccess(main) then
	return false
end

