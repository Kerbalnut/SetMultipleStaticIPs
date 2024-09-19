# set-ip-addresses.bat

Sets multiple static IPs on a network interface, or sets that inteface to DHCP.

Used for hopping between networks, programming different IP cameras, and changing you IP addresses frequently.

## To install

- Download the ZIP:
  1. Click the big green "Code" button towards the top right screen on GitHub website.
  2. Click "Download ZIP".
- Download the raw file:
  1. Click on the file "set-ip-addresses.bat" above on the GitHub website.
  2. Click "Raw" to see raw file text.
  3. Press Ctrl+S on keyboard to save the file onto your computer.

## To use

Double-click the .bat file. It will request Administrator permissions to change the network inteface settings. You must run this script As Administrator for it to work.

## To customize the script

Right-click the .bat file, and choose "Edit". By default this will open the file in Notepad.exe, but batch files can be edited in any text editor program. (Notepad++, vscode, etc.)

Make sure the `_NET_INTERFACE_NAME` variable is set to the name of the interface you want to change. E.g. for "Ethernet", it should read `SET "_NET_INTERFACE_NAME=Ethernet"`. To find out your network interface names, use the `ipconfig` command in command prompt/cmd.

Scroll down to the `SetStaticIPs` section, and edit the IP addresses and subnet masks you want to use.

