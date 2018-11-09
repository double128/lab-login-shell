#!/bin/bash
# LOGIN SHELL PRIMER
# This is used to "prime" the /etc/profile file into loading the login shell
# (loginshell_menu.sh). It's much better to keep these things separate.

# Remove the temporary IP routes used to authenticate with RADIUS
sudo ip route del 172.16.0.251/32 via 172.16.1.106 &> /dev/null 2>&1
sudo ip route del 172.16.0.252/32 via 172.16.1.106 &> /dev/null 2>&1
logger "Removed temporary IP routes to RADIUS server"

isLoaded=false
if [[ "$(whoami)" != "root" ]] && [[ "$isLoaded" = false ]]; then
	isLoaded=true
	exec /etc/config/customscripts/loginshell_menu.sh
fi
