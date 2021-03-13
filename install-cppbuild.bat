@echo off

:: Setup variables

:::: CurrentFolder
for %%i in ("%~dp0.") do set "CurrentFolder=%%~fi"

:::: ParentFolder (one above current)
for %%i in ("%~dp0..") do set "ParentFolder=%%~fi"

set NewPATHValue="%PATH%;%CurrentFolder%\bin"

set TAB=	

:: Actual install process
echo [Installing CppBuild]

goto ensureAdminRights

:proceedInstall

	echo 1. Adding "bin" folder%TAB%%TAB%to%TAB%PATH
	goto updatePATHInReg

:installStepTwo
	:: Note: this will update env vars without restarting PC
	echo 2. Setting LUA_PATH%TAB%%TAB%to%TAB%"%ParentFolder%\?\package.lua"
	CALL setx LUA_PATH "%ParentFolder%\?\package.lua" /m

	echo 3. Setting CPPBUILD_PATH%TAB%to%TAB%"%CurrentFolder%"
	CALL setx CPPBUILD_PATH "%CurrentFolder%" /m
	
:: End
echo.
echo Installation completed.
echo.
pause
goto programEnd

:: Ensui
:ensureAdminRights

    CALL net session >nul 2>&1
    if %errorLevel% == 0 (
		goto ensureNotInstalledYet
    ) else (
		echo [ERROR]
		echo %TAB%Administrator privileges required to set env vars.
		echo %TAB%Please run script with administrator privileges.
		pause
    )

:ensureNotInstalledYet
	if "%CPPBUILD_PATH%"=="" (
		goto proceedInstall
	) else (
		echo [ERROR]
		echo %TAB%CppBuild is already installed.
		echo [Details]
		echo %TAB%CPPBUILD_PATH is already set.
		echo [Hint]
		echo %TAB%To force reinstall remove CPPBUILD_PATH env var
		echo %TAB%and ensure PATH does NOT contain %%CPPBUILD_PATH%%\bin
		pause
		goto programEnd
	)

:updatePATHInReg	

	CALL reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path /d %NewPATHValue% /f
	goto installStepTwo

:programEnd
