#!/bin/bash
#
# IP ASSIGNER
# This script is needed to get our RADIUS server to set group names depending
# on the IP address the CM is attempting to be logged in to through. Users are
# required to log in to their pods with a specific IP address. 
#
# Please configure this script as follows:
# 	- 172.16.0.x, where "x" corresponds to the pod number
#	- 172.16.0.251 and .252 are the RADIUS server(s)
#	- 172.16.1.1xx is the CM's own NET1 IP address
# 
# NOTE: "exit 0" is *required* by pam_exec to know how to "leave" the script.


# We check for 3 things here:
#	1. Check if the IP the user initiated the SSH connection with exists.
#	2. Check if the user authenticating through PAM is the one who enacted #1.
#	3. Check if the PID of the SSH session is the one that corresponds to #1 and #2.

if [[ $(netstat -natpe | grep "172.16.0.11" | grep "$PAM_USER" | grep $PPID) ]]; then
	logger "$PAM_USER is connecting to Pod11"
	ip route add 172.16.0.251/32 via 172.16.1.106 src 172.16.0.11
	ip route add 172.16.0.252/32 via 172.16.1.106 src 172.16.0.11
	logger "Added IP route to RADIUS server via 172.16.0.11"
	
elif [[ $(netstat -natpe | grep "172.16.0.12" | grep "$PAM_USER" | grep $PPID) ]]; then
	logger "$PAM_USER is connecting to Pod12"
	ip route add 172.16.0.251/32 via 172.16.1.106 src 172.16.0.12
	ip route add 172.16.0.252/32 via 172.16.1.106 src 172.16.0.12
	logger "Added IP route to RADIUS server via 172.16.0.12"
	
else 
	echo "
		You haven't connected with the right IP address for this rack (6).
		Please use "172.16.0.11" for Pod 11, and "172.16.0.12" for Pod12."
fi

exit 0
