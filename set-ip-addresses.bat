@ECHO OFF

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

SET "_NET_INTERFACE_NAME=Ethernet"

CHOICE /C SD /M "Set 'Ethernet' to [S]tatic IPs, or set as [D]HCP?"
IF ERRORLEVEL 2 GOTO SetDHCP & REM No./DHCP
IF ERRORLEVEL 1 GOTO SetStaticIPs & REM Yes./Static
:NOCHOICE

:SetDHCP
ECHO Setting DHCP:
netsh interface ipv4 set address name="Ethernet" source=dhcp
GOTO End

:SetStaticIPs
ECHO Setting Static IPs:
REM netsh interface ipv4 set address name="Ethernet" static 192.168.1.25 255.255.255.0 192.168.1.1
:: US Bank:
netsh interface ipv4 add address "Ethernet" 192.168.1.25 255.255.255.0
netsh interface ipv4 add address "Ethernet" 192.168.120.40 255.255.255.0
:: Mayo:
netsh interface ipv4 add address "Ethernet" 10.232.0.1 255.255.0.0
netsh interface ipv4 add address "Ethernet" 10.233.52.1 255.255.0.0
netsh interface ipv4 add address "Ethernet" 10.233.56.1 255.255.0.0
netsh interface ipv4 add address "Ethernet" 10.233.60.1 255.255.0.0
netsh interface ipv4 add address "Ethernet" 10.233.64.1 255.255.0.0
netsh interface ipv4 add address "Ethernet" 10.233.68.1 255.255.0.0
netsh interface ipv4 add address "Ethernet" 10.233.72.1 255.255.0.0
netsh interface ipv4 add address "Ethernet" 10.233.76.1 255.255.0.0



:End
ECHO End of script.
Pause
EXIT
