#!/bin/bash
#	
# -- LOGIN SHELL MENU --
#
# DESCRIPTION: 	A login shell for lab users to access racked devices
# DATE: 	Summer 2018
# AUTHOR: 	A HAL 9000 computer
#
# INFORMATION: 
# - This script will load upon user login (so long as the user is not
#   root). The script is defined in a primer file (loginshell_primer.sh)
#   which is called in /etc/config/profile. 
#      -> "profile" is a file that is invoked upon user login. It loads
#	   loginshell_primer.sh to allow users to access this script.
#
# - I did *not* use this script as a user shell in /etc/config/passwd, 
#   due to the fact that the CM will reset any kind of changes made to
#   the file upon logging into the web UI. You cannot modify this kind
#   of behaviour. I am very limited with what I can work with.
#
# - This custom menu script is used as a replacement for pmshell, which
#   is the default login menu for devices. It looks like garbage, so I
#   improved on it (at Josh's request). 
#
# NOTE:
# If a user is in a specific group, their IP address will *always* line
# up with their group membership. In example, when a user connects with
# 172.16.0.11, then RADIUS will see this IP address and always put them
# into the group "pod11users". We perform checks for group membership 
# in this fashion.
# 
# We do not perform /etc/group checks for a specific reason I mentioned
# somewhere in the commments.
#

# Needed to display the selection menu correctly.
COLUMNS=1

# Get the IP that the user connected with for checks
SSH_IP="$(echo $SSH_CONNECTION | awk '{print $3}')"

# Root user should not have access to this script. There is a check in 
# /etc/config/profile to check for root, but in case the root user in-
# vokes the script manually, we can stop them.
if [[ "$(whoami)" == "root" ]]; then
echo "

You are logged in as root. The login shell is intended for users without 
Unix shell access. This script becomes a bit confused when a user has 
access to all available ports, so please avoid using it.
   -> Ports can be accessed by manually with 'pmshell -l portXX'.
   -> A list of accessible ports can be viewed with 'pmshell'.

If you need to access the PDU console ports, please use these commands:
   -> picocom /dev/ttyS31 (top PDU)
   -> picocom /dev/ttyS32 (middle PDU)

"
exit 1

# Begin non-root user checks. Accessing this requires group membership.
# Group membership is verified by SSH IP address and not what is defined
# in /etc/group. This cannot properly verify which group the user is in
# as I had modified pam_adduser to allow multiple-group membership through
# a remote authentication server.
else
	# Trap CTRL+C and CTRL+Z. Prevent users from exiting the script.
	#trap "" SIGINT SIGQUIT SIGTSTP

	# This one is special. Any time an "exit" is invoked (ie. CTRL+D
	# for EOF), it calls this eofkiller script.
	#trap "sh /etc/config/customscripts/eofkiller.sh" exit

	# Output for the user's pod number, depending on where they're
	# connected. This is handled by RADIUS. This is just used to
	# display what pod the user is connected to in the graphic.
	if [[ "$(sudo netstat -natpe | grep $SSH_IP | grep 172.16.0.11)" ]]; then 
		podNumber=11
	elif [[ "$(sudo netstat -natpe | grep $SSH_IP | grep 172.16.0.12)" ]]; then
		podNumber=12
	else
		# We can check here before the menu is shown to see if
		# an authenticated user is in the correct group. If they
		# arent, kick them out. This is to be interpreted as an
		# authentication error, as this should not display if 
		# things are working as intended.
		echo "ERROR: You aren't a member of any pod groups."
		exit;
	fi

	# This graphic uses Xterm colour codes. 
	# 	-> "38;5;x" is for text colours
	#	-> "48;5;y" is for background colour
	#	-> \e[0m returns colours to normal

echo -e "
  [#######################################################]
  |\e[48;5;17m                                                       \e[0m|
  |\e[38;5;19;48;5;17m     ooooo     ooo   .oooooo.   ooooo ooooooooooooo    \e[0m|
  |\e[38;5;20;48;5;17m     \`888'     \`8'  d8P'  \`Y8b  \`888' 8'   888   \`8    \e[0m|
  |\e[38;5;21;48;5;17m      888       8  888      888  888       888         \e[0m|
  |\e[38;5;27;48;5;17m      888       8  888      888  888       888         \e[0m|
  |\e[38;5;33;48;5;17m      888       8  888      888  888       888         \e[0m|
  |\e[38;5;39;48;5;17m      \`88.    .8'  \`88b    d88'  888       888         \e[0m|
  |\e[38;5;45;48;5;17m        \`YbodP'     \`Y8bood8P'  o888o     o888o        \e[0m|
  |\e[38;5;159;48;5;17m             Challenge. Innovate. Connect.             \e[0m|
  |\e[48;5;17m                                                       \e[0m|
  +--------------\e[1;38;5;27;48;5;45m ACCESS SERVER - RACK 6 \e[0m-----------------+          
  |                     > \e[38;5;33mPod ${podNumber}\e[m <                        |
  |                                                       |  
  |  Welcome to the \e[1;38;5;33mUOIT Networking Lab\e[0m access server.    |
  |                                                       |
  |  Input a number to select a device from list below.   |  
  |  This menu is best viewed with Tera Term or PuTTY.    |  
  |                                                       |
  |               \e[1;38;5;202m|\e[37;1m| \e[38;5;202m|| \e[38;5;40m|\e[37;1m| \e[38;5;27m|| |\e[37;1m| \e[38;5;40m|| \e[38;5;130m|\e[37;1m| \e[38;5;130m||\e[0m                 |
  |               \e[1;38;5;202m|\e[37;1m| \e[38;5;202m|| \e[38;5;40m|\e[37;1m| \e[38;5;27m|| |\e[37;1m| \e[38;5;40m|| \e[38;5;130m|\e[37;1m| \e[38;5;130m||\e[0m                 |
  |               \e[1;38;5;202m|\e[37;1m| \e[38;5;202m|| \e[38;5;40m|\e[37;1m| \e[38;5;27m|| |\e[37;1m| \e[38;5;40m|| \e[38;5;130m|\e[37;1m| \e[38;5;130m||\e[0m                 |
  |               \e[1;38;5;202m|\e[37;1m| \e[38;5;202m|| \e[38;5;40m|\e[37;1m| \e[38;5;27m|| |\e[37;1m| \e[38;5;40m|| \e[38;5;130m|\e[37;1m| \e[38;5;130m||\e[0m                 |
  |                                                       |  
  |  For support, please visit \e[38;5;45mlabsupport.fbit.uoit.ca\e[0m.   |  
  |							  |
  |             To log off, press \e[1;38;5;33mCTRL + D\e[0m.               |
  |							  |
  [#######################################################]
"

	PS3="> "
	
	# Define variables for group membership checks.
	POD1="172.16.0.11"
	POD2="172.16.0.12"
	PODCHECK="$(sudo netstat -natpe | grep $(whoami) | grep $SSH_IP | awk '{print $4}' | cut -d':' -f1)"
	
	# We need to specify which ports the user can connect to through pmshell.
	# pmshell -l port01-08 is for Pod 1 devices, and port09-16 is for Pod 2.
	select choice in "R1" "R2" "R3" "R4" "SW1 (DLS1)" "SW2 (DLS2)" "SW3 (ALS1)" "SW4 (ALS2)" "Power menu"; do
		if [[ "$PODCHECK" == "$POD1" ]]; then	
			case $REPLY in
				1) pmshell -l port01;;
				2) pmshell -l port02;;
				3) pmshell -l port03;;
				4) pmshell -l port04;;
				5) pmshell -l port05;;
				6) pmshell -l port06;;
				7) pmshell -l port07;;
				8) pmshell -l port08;;
				9) sh /etc/config/customscripts/loginshell_powermenu.sh;;
			esac
		elif [[ "$PODCHECK" == "$POD2" ]]; then
			case $REPLY in
				1) pmshell -l port09;;
				2) pmshell -l port10;;
				3) pmshell -l port11;;
				4) pmshell -l port12;;
				5) pmshell -l port13;;
				6) pmshell -l port14;;
				7) pmshell -l port15;;
				8) pmshell -l port16;;
				9) sh /etc/config/customscripts/loginshell_powermenu.sh;;
			esac
		else
			echo "ERROR: You are not in the correct group for this login menu."
		fi
	done
fi
clear
