@echo off
echo [CppBuild] Build process started
premake5 --file="%CPPBUILD_PATH%\src\runner\Runner.lua" %*
echo [CppBuild] Build process finished