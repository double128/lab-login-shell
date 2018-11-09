#!/bin/bash
#
# IP ASSIGNER
# This script is needed to get our RADIUS server to set group names depending
# on the IP address the CM is attempting to be logged in to through. Users are
# required to log in to their pods with a specific IP address.
#
# Please configure this script as follows:
#       - 172.16.2.x, where "x" corresponds to the pod number
#       - 172.16.2.251 is the RADIUS server
#       - 172.16.2.1xx is the CM's own NET1 IP address
#
# NOTE: "exit 0" is *required* by pam_exec to know how to "leave" the script.

. /etc/config/customscripts/variables
rackCheck

# Look for leftover IP routes from a failed authentication attempt and remove them
if [[ $(ip route | grep "172.16.2.251 via 172.16.2.20") ]]; then
        ip route del 172.16.2.251 via ${RACKIP}
fi

# We check for the IP that the user has logged in with, then create an IP route that uses this IP to communicate
# with the RADIUS server for authentication purposes. This is needed so the RADIUS server knows which group it has
# to put users into (ie. 172.16.2.1 will get users placed in the Pod1 group).

if [[ ${PAM_USER} != "root" ]]; then
### POD1 ####
echo "Pod1 check"
if [[ $(netstat -natpe | grep sshd | awk '{if ($4 == "'${POD1IP}:22'") print $9}' | cut -d / -f1 | grep $PPID) ]]; then
        # Non-keyboard interactive authentication, where PPID = sshd [priv] PID
        #echo "Pod1 nonkeyboard"
        ip route add 172.16.2.251/32 via $RACKIP src $POD1IP
elif [[ $(ps | grep $PAM_USER | grep pam | grep $PPID) ]]; then
        # Keyboard interactive authentication, where PPID != sshd PID, but instead PPID == sshd [pam]
        #echo "Pod1 keyboard"
        ip route add 172.16.2.251/32 via $RACKIP src $POD1IP
fi

# SSH_PID=$(netstat -natpe | grep sshd | awk '{if ($4 == "'${POD1IP}:22'") print $9}' | cut -d / -f1 | grep
# $(ps | grep $PAM_USER | grep priv | grep $SSH_PID)


### POD2 ####
echo "Pod2 check"
if [[ $(netstat -natpe | grep sshd | awk '{if ($4 == "'${POD2IP}:22'") print $9}' | cut -d / -f1 | grep $PPID) ]]; then
        #echo "Pod2 nonkeyboard"
        ip route add 172.16.2.251/32 via $RACKIP src $POD2IP
elif [[ $(ps | grep $PAM_USER | grep pam | grep $PPID) ]]; then
        #echo "Pod2 keyboard"
        ip route add 172.16.2.251/32 via $RACKIP src $POD2IP
fi

### POD3 ####
echo "Pod3 check"
if [[ $(netstat -natpe | grep sshd | awk '{if ($4 == "'${POD3IP}:22'") print $9}' | cut -d / -f1 | grep $PPID) ]]; then
        #echo "Pod3 nonkeyboard"
        ip route add 172.16.2.251/32 via $RACKIP src $POD3IP
elif [[ $(ps | grep $PAM_USER | grep pam | grep $PPID) ]]; then
        #echo "Pod3 keyboard"
        ip route add 172.16.2.251/32 via $RACKIP src $POD3IP
fi

### POD4 ####
echo "Pod4 check"
if [[ $(netstat -natpe | grep sshd | awk '{if ($4 == "'${POD4IP}:22'") print $9}' | cut -d / -f1 | grep $PPID) ]]; then
        #echo "Pod4 nonkeyboard"
        ip route add 172.16.2.251/32 via $RACKIP src $POD4IP
elif [[ $(ps | grep $PAM_USER | grep pam | grep $PPID) ]]; then
        #echo "Pod4 keyboard"
        ip route add 172.16.2.251/32 via $RACKIP src $POD4IP
fi
fi

exit 0
