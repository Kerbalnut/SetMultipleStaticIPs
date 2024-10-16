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


:RunAsAdministrator
:: BatchGotAdmin International-Fix Code
:: https://sites.google.com/site/eneerge/home/BatchGotAdmin
:-------------------------------------------------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
IF '%ERRORLEVEL%' NEQ '0' (
    REM ECHO Requesting administrative privileges... ^(waiting 2 seconds^)
	REM PING -n 3 127.0.0.1>nul
    GOTO UACPrompt
) ELSE ( GOTO gotAdmin )

:UACPrompt
    ECHO Set UAC = CreateObject^("Shell.Application"^) > "%Temp%\getadmin.vbs"
    ECHO UAC.ShellExecute "%~s0", "", "", "RUNAS", 1 >> "%Temp%\getadmin.vbs"

    "%Temp%\getadmin.vbs"
    EXIT /B

:gotAdmin
    IF EXIST "%Temp%\getadmin.vbs" ( DEL "%Temp%\getadmin.vbs" )
    PUSHD "%CD%"
    CD /D "%~dp0"
	ECHO BatchGotAdmin Permissions set.
:-------------------------------------------------------------------------------
:: End Run-As-Administrator function

:MainVars
SET "_NET_INTERFACE_NAME=Ethernet"
:: By default, this is set to "Ethernet". Use the `ipconfig` command to discover your network interface names.

:StartScript
CHOICE /C SD /M "Set '%_NET_INTERFACE_NAME%' to [S]tatic IPs, or set as [D]HCP?"
IF ERRORLEVEL 2 GOTO SetDHCP & REM No./DHCP
IF ERRORLEVEL 1 GOTO SetStaticIPs & REM Yes./Static
:NOCHOICE

:SetDHCP
ECHO Setting DHCP:
netsh interface ipv4 set address name="%_NET_INTERFACE_NAME%" source=dhcp
::netsh interface ipv4 set address "%_NET_INTERFACE_NAME%" dhcp
::netsh interface ip show config
GOTO End

:SetStaticIPs
ECHO Setting Static IPs:
REM netsh interface ipv4 set address name="Ethernet" static 192.168.1.25 255.255.255.0 192.168.1.1

:: Network 1:
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 192.168.0.25 255.255.255.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 192.168.1.25 255.255.255.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 192.168.120.40 255.255.255.0
:: Network 2:
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.0.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.52.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.56.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.60.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.64.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.68.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.72.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.76.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.12.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.172.1 255.255.0.0

netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.40.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.56.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.133.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.140.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.152.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.160.1 255.255.0.0




GOTO End

:End
ipconfig /all
ECHO:
ECHO End of script.
Pause
EXIT
