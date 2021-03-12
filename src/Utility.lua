Utility = {
	gen = { }
}

function Utility.gen.isVisualStudio()
	return string.match(_ACTION, "vs%d%d%d%d") ~= nil
end

function Utility.gen.isGMake()
	return string.match(_ACTION, "gmake(2)?") ~= nil
end

function Utility.exportSymbols(pathToSymbolsFile)
	linkoptions { "/DEF:\"" .. pathToSymbolsFile .. "\""}
end

-- Configures PCH for current project
-- Example:
-- - projectName: Engine
-- - macro: SAMPCPP_PCH
-- Results in:
-- - pchheader "include/Engine/EnginePCH.hpp"
-- - pchsource "src/EnginePCH.hpp"
-- - SAMPCPP_PCH="include/Engine/EnginePCH.hpp"
-----^^^^^^^^^^^^^^^^^ - defined macro
function Utility.configurePCH(pchHeader, pchSource, pchMacro)
	pchheader (pchHeader)
	pchsource (pchSource)
	defines { pchMacro .. "=\"" .. pchHeader .. "\"" }
	includedirs { "." }
end

-- Used to retarget VS solution and projects.
-- Returns version of Windows SDK.
function Utility.getWindowsSDKVersion()
    local reg_arch = iif( os.is64bit(), "\\Wow6432Node\\", "\\" )
    local sdk_version = os.getWindowsRegistry( "HKLM:SOFTWARE" .. reg_arch .."Microsoft\\Microsoft SDKs\\Windows\\v10.0\\ProductVersion" )
    if sdk_version ~= nil then return sdk_version end
end

function Utility.initWorkspace()
	platforms { "x86", "x64" }
	configurations { "Debug", "Release" }

	if os.host() == "macosx" then
		removeplatforms { "x86" }
	end

	-- gmake specific configuration
	if Utility.gen.isGMake() then
		links {
			"dl",
			"stdc++fs",
			"pthread"
		}
	end	

	filter "platforms:*32"
		architecture "x86"

	filter "platforms:*64"
		architecture "x86_64"

	filter "configurations:Debug"
		defines { "DEBUG" }
		symbols "On"

	filter "configurations:Release"
		defines { "NDEBUG" }
		optimize "On"

	filter {}

	-- A workaround for dumb Windows.h. IDK where it is included, couldn't find it.
	defines { "NOMINMAX "}
end

return Utility