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

:SkipChoosingInterface
GOTO MainVars


:StartScript
CLS
ECHO:
ECHO:
CHOICE /C SD /M "Set '%_NET_INTERFACE_NAME%' to [S]tatic IPs, or set as [D]HCP?"
IF ERRORLEVEL 2 GOTO SetDHCP & REM No./DHCP
IF ERRORLEVEL 1 GOTO SetStaticIPs & REM Yes./Static
:NOCHOICE



:: Get network interface names to choose from:
:: wmic nic get AdapterType, Name, Installed, MACAddress, PowerManagementSupported, Speed

netsh interface show interface

netsh interface ipv4 show config "Wi-Fi"

commandA && commandB || commandC

commandA && ECHO Command succeeded! || ECHO Command failed.

netsh interface ipv4 show config "Wi-Fi" && ECHO Command succeeded! || ECHO Command failed.
netsh interface ipv4 show config "Wi-Few" && ECHO Command succeeded! || ECHO Command failed.

netsh interface ipv4 show config "Wi-Fi" >nul 2>&1 && ECHO Command succeeded! || ECHO Command failed. 
netsh interface ipv4 show config "Wi-Few" >nul 2>&1 && ECHO Command succeeded! || ECHO Command failed.


:MainVars
SET "_NET_INTERFACE_NAME=Ethernet"
:: By default, this is set to "Ethernet". Use the `ipconfig` command to discover your network interface names.

:StartScript
CLS
ECHO:
ECHO:
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
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 192.168.0.2 255.255.255.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 192.168.1.2 255.255.255.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 192.168.120.49 255.255.255.0
:: Network 2:
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.0.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.2.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.4.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.6.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.8.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.12.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.16.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.20.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.32.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.36.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.40.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.48.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.52.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.64.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.68.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.72.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.84.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.92.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.96.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.100.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.108.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.112.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.116.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.120.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.124.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.128.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.132.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.136.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.144.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.148.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.164.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.168.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.172.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.176.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.232.180.1 255.255.0.0

netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.12.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.52.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.56.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.60.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.64.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.68.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.72.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 10.233.76.1 255.255.0.0

netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.16.34.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.16.154.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.24.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.28.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.32.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.36.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.40.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.56.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.68.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.72.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.76.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.133.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.134.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.135.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.136.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.137.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.139.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.140.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.144.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.148.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.152.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.160.1 255.255.0.0
netsh interface ipv4 add address "%_NET_INTERFACE_NAME%" 172.17.192.1 255.255.0.0



GOTO End

:End
ipconfig /all
ECHO:
ECHO End of script.
Pause
EXIT
