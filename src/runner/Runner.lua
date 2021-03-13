os.chdir(_WORKING_DIR)

local cb = require("CppBuild")

local project = require(path.join(_WORKING_DIR, "package"))

cb.quick.project(project)


