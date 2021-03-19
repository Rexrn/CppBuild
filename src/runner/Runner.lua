os.chdir(_WORKING_DIR)

local cb = require("CppBuild")

Packages = cb.PackageManager.new()

local project = require(path.join(_WORKING_DIR, "package"))

cb.quick.autodetect(project)


