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

:MainVars
SET "_NET_INTERFACE_NAME=Ethernet"
:: By default, this is set to "Ethernet". Use the `ipconfig` command to discover your network interface names.

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

::GOTO SKIPADMIN & REM <-- Leave this line in to always skip Elevation Prompt -->
GOTO RUNASADMIN & REM <-- Leave this line in to always Run As Administrator (skip choice) -->
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

GOTO CheckInterfaceName
:OpenControlPanelNetworkAdapters
ncpa.cpl

:: commandA && commandB || commandC
:: commandA && ECHO Command succeeded! || ECHO Command failed.

:: netsh interface ipv4 show config "Wi-Fi" >nul 2>&1 && ECHO Command succeeded! || ECHO Command failed. 
:: netsh interface ipv4 show config "Wi-Few" >nul 2>&1 && ECHO Command succeeded! || ECHO Command failed. 

:CheckInterfaceName
netsh interface ipv4 show config "%_NET_INTERFACE_NAME%" >nul 2>&1 && GOTO DefaultInterfaceDetected || GOTO DefaultInterfaceNotDetected

:DefaultInterfaceNotDetected
ECHO Selected interface does not exist! '%_NET_INTERFACE_NAME%'
CLS
GOTO TypeInterfacece

:DefaultInterfaceDetected
CLS

::GOTO ChooseIPs

ECHO:
ECHO Default interface selected = "%_NET_INTERFACE_NAME%"
ECHO:
netsh interface show interface
ECHO:
ECHO (To change the Default Interface name, right-click and edit this file: '%~nx0')
::ECHO %~f0
:ChooseInterface
ECHO:
CHOICE /C YN /M "Use interface '%_NET_INTERFACE_NAME%' [Y]es, or [N]o select a different one?"
IF ERRORLEVEL 2 GOTO TypeInterfacece & REM No.
IF ERRORLEVEL 1 GOTO ChooseIPs & REM Yes.
GOTO ChooseIPs
:NOCHOICEInterface

:: Get network interface names to choose from:
:: wmic nic get AdapterType, Name, Installed, MACAddress, PowerManagementSupported, Speed

netsh interface show interface

netsh interface ipv4 show addresses

netsh interface ipv4 show config "Wi-Fi"

netsh interface ipv4 show config "%_NET_INTERFACE_NAME%"

FOR /f "tokens=4 delims=(=" %%G IN ('%_cmd% ^|find "loss"') DO echo Result is [%%G]



:TypeInterfacece
CLS
GOTO TypeInterfaceGo
:TypeInterfaceError
CLS
ECHO:
ECHO ERROR: Interface name '%_NET_INTERFACE_NAME%' not recognized.
:TypeInterfaceGo
ECHO:
ECHO Select network interface to set IPs on:
ECHO:
netsh interface show interface
ECHO:
SET /P "_NET_INTERFACE_NAME=Type in Interface Name: "

:: netsh interface ipv4 show config "Wi-Fi" >nul 2>&1 && ECHO Command succeeded! || ECHO Command failed.
netsh interface ipv4 show config "%_NET_INTERFACE_NAME%" >nul 2>&1 && GOTO ChooseIPs || GOTO TypeInterfaceError

:ChooseIPs
::CLS
:: Wait 1 second
PING -n 2 127.0.0.1 > nul
ECHO:
ECHO Enabling network adapter '%_NET_INTERFACE_NAME%'
netsh interface set interface name="%_NET_INTERFACE_NAME%" admin=ENABLED
:: Wait 1 second
PING -n 2 127.0.0.1 > nul
ECHO:
netsh interface ipv4 show config "%_NET_INTERFACE_NAME%"
ECHO:
CHOICE /C SD /M "Set '%_NET_INTERFACE_NAME%' with [S]tatic IPs, or set as [D]HCP?"
IF ERRORLEVEL 2 GOTO SetDHCP & REM No./DHCP
IF ERRORLEVEL 1 GOTO SetStaticIPs & REM Yes./Static
:NOCHOICEIPs

:SetDHCP
SET "_SET_STATIC_DHCP=DHCP"
ECHO:
:: Wait 2 seconds
PING -n 3 127.0.0.1 > nul
ECHO Disabling network adapter '%_NET_INTERFACE_NAME%'
netsh interface set interface name="%_NET_INTERFACE_NAME%" admin=DISABLED
:: Wait 2 seconds
PING -n 3 127.0.0.1 > nul
netsh interface ipv4 set address name="%_NET_INTERFACE_NAME%" source=dhcp
:: Wait 2 seconds
PING -n 3 127.0.0.1 > nul
ECHO:
ECHO Enabling network adapter '%_NET_INTERFACE_NAME%'
netsh interface set interface name="%_NET_INTERFACE_NAME%" admin=ENABLED
:: Wait 2 seconds
PING -n 3 127.0.0.1 > nul
netsh interface ipv4 set address name="%_NET_INTERFACE_NAME%" source=dhcp
:: Wait 2 seconds
PING -n 3 127.0.0.1 > nul
ECHO:
ECHO Reset IPV4 interfaces:
ECHO:
netsh interface ipv4 reset
:: Wait 2 seconds
PING -n 3 127.0.0.1 > nul
ECHO:

::netsh interface ipv4 delete addresss gateway=all

ECHO Setting DHCP:
netsh interface ipv4 set address name="%_NET_INTERFACE_NAME%" source=dhcp
::netsh interface ipv4 set address "%_NET_INTERFACE_NAME%" dhcp
::netsh interface ip show config
GOTO End

:SetStaticIPs
SET "_SET_STATIC_DHCP=Static"
ECHO:
ECHO Setting Static IPs:
REM netsh interface ipv4 set address name="Ethernet" static 192.168.1.25 255.255.255.0 192.168.1.1

:: Network 1:
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 192.168.0.2 255.255.255.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 192.168.1.2 255.255.255.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 192.168.120.49 255.255.255.0
:: Network 2:
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.37.207.129 255.255.255.192
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.210.177.2 255.255.255.0
:: Network 3:
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.0.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.2.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.4.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.6.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.8.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.12.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.16.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.20.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.32.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.36.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.40.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.48.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.52.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.64.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.68.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.72.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.84.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.92.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.96.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.100.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.108.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.112.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.116.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.120.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.124.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.128.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.132.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.136.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.144.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.148.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.164.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.168.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.172.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.176.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.180.1 255.255.252.0

netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.12.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.52.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.56.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.60.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.64.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.68.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.72.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.76.1 255.255.252.0

netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.16.34.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.16.154.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.24.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.28.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.32.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.36.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.40.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.56.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.68.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.72.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.76.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.133.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.134.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.135.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.136.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.137.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.139.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.140.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.144.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.148.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.152.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.160.1 255.255.252.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.192.1 255.255.252.0



GOTO End

:End
IF "%_SET_STATIC_DHCP%"=="DHCP" ECHO Finished setting DHCP on '%_NET_INTERFACE_NAME%'.
IF "%_SET_STATIC_DHCP%"=="Static" ECHO Finished setting static IP addresses on '%_NET_INTERFACE_NAME%'.
ECHO:
ECHO Check network adapter properties in Control Panel.
ncpa.cpl
::GOTO SkipResetAdapter
ECHO:
:: Wait 2 seconds
PING -n 3 127.0.0.1 > nul
ECHO Disabling network adapter '%_NET_INTERFACE_NAME%'
netsh interface set interface name="%_NET_INTERFACE_NAME%" admin=DISABLED
:: Wait 2 seconds
PING -n 3 127.0.0.1 > nul
IF "%_SET_STATIC_DHCP%"=="DHCP" (
	netsh interface ipv4 set address name="%_NET_INTERFACE_NAME%" source=dhcp
	:: Wait 2 seconds
	PING -n 3 127.0.0.1 > nul
)
ECHO:
ECHO Enabling network adapter '%_NET_INTERFACE_NAME%'
netsh interface set interface name="%_NET_INTERFACE_NAME%" admin=ENABLED
:: Wait 2 seconds
PING -n 3 127.0.0.1 > nul
GOTO SkipResetAdapter
IF "%_SET_STATIC_DHCP%"=="DHCP" (
	netsh interface ipv4 set address name="%_NET_INTERFACE_NAME%" source=dhcp
	:: Wait 2 seconds
	PING -n 3 127.0.0.1 > nul
)
ECHO:
ECHO Reset IPV4 interfaces:
ECHO:
netsh interface ipv4 reset
:: Wait 2 seconds
PING -n 3 127.0.0.1 > nul
ECHO:
:SkipResetAdapter
ECHO:
::ipconfig /all
netsh interface ipv4 show config "%_NET_INTERFACE_NAME%"
ECHO:
netsh interface ipv4 show ipaddresses
ECHO:
ECHO (Try running script again if changes don't appear here. Check Network Adapter Properties.)
ECHO:
ECHO End of script '%~nx0'.
PAUSE
EXIT
