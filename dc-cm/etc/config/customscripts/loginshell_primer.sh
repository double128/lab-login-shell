#!/bin/bash
#
# LOGIN SHELL PRIMER
# This is used to "prime" the /etc/profile file into loading the login shell
# (loginshell_menu.sh). It's much better to keep these things separate.
#

# Remove the temporary IP routes used to authenticate with RADIUS
sudo ip route del 172.16.2.251/32 &> /dev/null 2>&1

isLoaded=false
if [[ "$(whoami)" != "root" ]] && [[ "$isLoaded" = false ]]; then
        isLoaded=true
        exec /etc/config/customscripts/loginshell_menu.sh
fi
