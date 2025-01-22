@ECHO OFF

:: SUMMARY:
:: Set multiple static IP addresses on an interface, or change it to DHCP.
:: DESCRIPTION:
:: Useful for programming multiple different IP camera brands & models, which can use many different default IP address ranges.
:: Also useful in general for any kind of physical network hopping with a laptop.
:: NOTES:
:: Change the "_NET_INTERFACE_NAME" variable (below near the "MainVars" tag) to match the interface you want to change. Find out interface names by using the "ipconfig" command.
:: Adjust the static IPs and subnet masks under the "SetStaticIPs" tag.
:: EXAMPLE:
:: Doulbe-click on this script to launch it. It will offer you a choice of setting the static IPs (below) or setting the interface to use DHCP.


REM ECHO DEBUGGING: Begin RunAsAdministrator block.
:RunAsAdministrator
:: SS64 Run with elevated permissions script (ElevateMe.vbs)
:: Thanks to: http://ss64.com/vb/syntax-elevate.html
:-------------------------------------------------------------------------------
:: First check if we are already running As Admin/Elevated
FSUTIL dirty query %SystemDrive% >nul
IF %ERRORLEVEL% EQU 0 SET "_ADMIN=TRUE" & GOTO START

:: Check input parameters
REM ECHO DEBUGGING: Parameter %%1: "%1"
IF "%1"=="RunAsAdmin" GOTO RUNASADMIN
IF "%1"=="NoAdmin" GOTO SKIPADMIN

GOTO SKIPADMIN & REM <-- Leave this line in to always skip Elevation Prompt -->
::GOTO RUNASADMIN & REM <-- Leave this line in to always Run As Administrator (skip choice) -->
:: Comment out both GOTO statements to prompt user to elevate.
ECHO:
ECHO CHOICE Loading...
ECHO:
:: https://ss64.com/nt/choice.html
CHOICE /M "Run as Administrator? (CMD.EXE/VBScript elevation)"
IF ERRORLEVEL 2 GOTO SKIPADMIN & REM No.
IF ERRORLEVEL 1 REM Yes.
:RUNASADMIN

:: wait 2 seconds, in case this user is not in Administrators group. (To prevent an infinite loop of UAC admin requests on a restricted user account.)
ECHO Requesting administrative privileges... ^(waiting 2 seconds^)
PING -n 3 127.0.0.1 > nul

::Create and run a temporary VBScript to elevate this batch file
	:: https://ss64.com/nt/syntax-args.html
	SET _batchFile=%~s0
	SET _batchFile=%~f0
	SET _Args=%*
	IF NOT [%_Args%]==[] (
		REM double up any quotes
		REM https://ss64.com/nt/syntax-replace.html
		SET "_Args=%_Args:"=""%"
		REM Bugfix: cannot use :: for comments within IF statement, instead use REM
	)
	:: https://ss64.com/nt/if.html
	IF ["%_Args%"] EQU [""] ( 
		SET "_CMD_RUN=%_batchFile%"
	) ELSE ( 
		SET "_CMD_RUN=""%_batchFile%"" %_Args%"
	)
	:: https://ss64.com/vb/shellexecute.html
	ECHO Set UAC = CreateObject^("Shell.Application"^) > "%Temp%\~ElevateMe.vbs"
	ECHO UAC.ShellExecute "CMD", "/C ""%_CMD_RUN%""", "", "RUNAS", 1 >> "%Temp%\~ElevateMe.vbs"
	:: ECHO UAC.ShellExecute "CMD", "/K ""%_batchFile% %_Args%""", "", "RUNAS", 1 >> "%temp%\~ElevateMe.vbs"
	
	cscript "%Temp%\~ElevateMe.vbs" 
	EXIT /B

GOTO START
:SKIPADMIN
SET "_ADMIN=FALSE"
:START
:: set the current directory to the batch file location
::CD /D %~dp0
:-------------------------------------------------------------------------------
:: End Run-As-Administrator function

ECHO:
ECHO -------------------------------------------------------------------------------
ECHO:
ECHO Pinging default IP addresses.
ECHO:
ECHO Are your interface addresses set to the same network?

ECHO:
ECHO -------------------------------------------------------------------------------
ECHO:
ECHO 192.168.0.90 (Axis) . . . 
ping -n 1 192.168.0.90

ECHO:
ECHO -------------------------------------------------------------------------------
ECHO:
ECHO 192.168.1.100 (Wisenet/Hanwha) . . . 
ping -n 1 192.168.1.100

ECHO:
ECHO -------------------------------------------------------------------------------
ECHO:
ECHO 192.168.0.10 (iPro default PTZ) . . . 
ping -n 1 192.168.0.10

ECHO:
ECHO -------------------------------------------------------------------------------
ECHO:
ECHO 192.168.0.11 (iPro default non-PTZ) . . . 
ping -n 1 192.168.0.11

ECHO:
ECHO -------------------------------------------------------------------------------
ECHO:
ECHO 192.168.120.50 (USB Default Cams) . . . 
ping -n 1 192.168.120.50



GOTO End

:End
ECHO:
ECHO -------------------------------------------------------------------------------
ECHO:
ECHO End of script.
Pause
EXIT
