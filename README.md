# Networking Lab Login Shell
Been working on this (poorly-made) login shell, which will be properly deployed at the start of the school year. I've uploaded it to Github mainly so I can have a backup of the loginshell scripts (just in case something goes horribly wrong). It's pretty messy and is filled to the brim with if statements.

Some of the variables/IP addresses used are specific to one rack and one rack only. Modification is required to get these to work with other racks. 

Here's a quick run-down of the scripts used:

#### loginshell_ipassign.sh
This is the first script that runs, which is called by pam_exec. It loads before RADIUS authentication occurs. Basically, we want the CM these scripts are running on to handle 2 sets of "pods", which each have their own IP alias assigned to them. The script is loaded before the user enters their username and password. 

It will check the incoming IP address used to connect to the CM, and then set an IP route to the RADIUS server from that IP address (it's a bit weird, I know, but without this, the RADIUS server will only receive the IP address of the CM itself, not the IP aliases used to connect to it). 

One of the issues with writing this script was the inability to call the environment variable $SSH_CONNECTION. At the time we believed that we needed this variable to perform a check. This check was required, because at the time, the if statements only checked netstat for the IP address. There were no other checks to ensure that the SSH session was unique and not already open. This resulted in there being issues if any user connecting to the rack connected to the first pod. This would prevent any user assigned to the rack from accessing the second pod, because the script would perform a check to see if there was a connection from the first pod's IP. If this connection already existed (as per another user being connected from it), it would just say that the user is trying to connect to the first pod even though they are using the pod 2 IP address to connect to the CM.

It took me some days of thinking to realize that I could call $PPID (which would return the SSH session) to compare it against netstat (which lists $PPID in its table). Basically, I needed a way to guarantee that the session was unique. I figured that one out. $PAM_USER also allows the script to do another check that ensures that the connection is unique, but $PPID pretty much does the job in the best way possible.

#### loginshell_primer.sh
This script is called in /etc/config/profile whenever a user logs in. It functions as a wrapper to call the loginshell menu script and prevents the script from loading more than once. It also removes the IP routes added by the script above.

#### loginshell_menu.sh
The actual menu that is shown to a user. The comments in the script sum it up pretty nicely. It basically prevents the root user from using the script (because it causes errors; the script gets confused when it sees that a user has access to all ports). It checks the user's SSH IP rather than their group membership because users at a certain IP address are *guaranteed* to be in a specific group (as per RADIUS authentication). 

#### loginshell_powermenu.sh
A menu accessed from loginshell_menu that allows users to control the power of devices they have access to. Invokes powerman to turn on/off devices. Nothing special.

#### eofkiller.h
Prevents users from invoking CTRL+D and exiting scripts. For their crimes, all their processes are killed and they are forcibly removed from the premises. 
