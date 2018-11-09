#!/bin/bash
#
# LOGIN SHELL POWER MENU
# This is called by the login shell (loginshell_menu.sh). 
# Users will be able to access power options for every device in the rack, 
# all in one convenient space (rather than manually turning off each device
# one at a time... it gets annoying).
# 
# TODO:
#
COLUMNS=1

SSH_IP="$(echo $SSH_CONNECTION | awk '{print $3}')"
POD1="172.16.0.11"
POD2="172.16.0.12"
PODCHECK="$(sudo netstat -natpe | grep $(whoami) | grep $SSH_IP | awk '{print $4}' | cut -d':' -f1)"

# Function for querying powerman information. Accounts for Pod1 and Pod2's existence.
# This menu displays when the power menu is first accessed. It displays the current
# state of each port in the pod.
# This function MUST be called every time an update is made to a device's power state.
powerQuery() {
	if [[ "$PODCHECK" == "$POD1" ]]; then
        	clear
        	echo -n " > Querying power status"
        	
        	# Pod1 R1 (Port 1)
        	if [[ $(powerman -Q port32_0 | grep 'off:     port') ]]; then
        	        r1_output=$(echo -e "R1 STATUS:	\e[31mOFF\e[0m")
        	elif [[ $(powerman -Q port32_0 | grep 'on:      port') ]]; then
        	        r1_output=$(echo -e "R1 STATUS:	\e[32mON\e[0m")
        	fi
		
		echo -n "."
		
	        # Pod1 R2 (Port 2)
	        if [[ $(powerman -Q port32_1 | grep 'off:     port') ]]; then
	                r2_output=$(echo -e "R2 STATUS:	\e[31mOFF\e[0m")
	        elif [[ $(powerman -Q port32_1 | grep 'on:      port') ]]; then
	                r2_output=$(echo -e "R2 STATUS:	\e[32mON\e[0m")
	        fi
	        
	        echo -n "."

	        # Pod1 R3 (Port 3)
	        if [[ $(powerman -Q port32_2 | grep 'off:     port') ]]; then
	                r3_output=$(echo -e "R3 STATUS:	\e[31mOFF\e[0m")
	        elif [[ $(powerman -Q port32_2 | grep 'on:      port') ]]; then
	                r3_output=$(echo -e "R3 STATUS:	\e[32mON\e[0m")
	        fi
		
		echo -n "."
		
	        # Pod1 R4 (Port 4)
	        if [[ $(powerman -Q port32_3 | grep 'off:     port') ]]; then
	                r4_output=$(echo -e "R4 STATUS:	\e[31mOFF\e[0m")
	        elif [[ $(powerman -Q port32_3 | grep 'on:      port') ]]; then
	                r4_output=$(echo -e "R4 STATUS:	\e[32mON\e[0m")
	        fi
		
		echo -n "."
		
	        # Pod1 SW1 (Port 5)
	        if [[ $(powerman -Q port32_4 | grep 'off:     port') ]]; then
	                sw1_output=$(echo -e "SW1 STATUS:	\e[31mOFF\e[0m")
	        elif [[ $(powerman -Q port32_4 | grep 'on:      port') ]]; then
	                sw1_output=$(echo -e "SW1 STATUS:	\e[32mON\e[0m")
	        fi
		
		echo -n "."
		
	        # Pod1 SW2 (Port 6)
	        if [[ $(powerman -Q port32_5 | grep 'off:     port') ]]; then
	                sw2_output=$(echo -e "SW2 STATUS:	\e[31mOFF\e[0m")
	        elif [[ $(powerman -Q port32_5 | grep 'on:      port') ]]; then
        	        sw2_output=$(echo -e "SW2 STATUS:	\e[32mON\e[0m")
	        fi
		
		echo -n "."
		
	        # Pod1 SW3 (Port 7)
	        if [[ $(powerman -Q port32_6 | grep 'off:     port') ]]; then
	                sw3_output=$(echo -e "SW3 STATUS:	\e[31mOFF\e[0m")
	        elif [[ $(powerman -Q port32_6 | grep 'on:      port') ]]; then
       	        	sw3_output=$(echo -e "SW3 STATUS:	\e[32mON\e[0m")
		fi
	
		echo -n "."
	
		# Pod1 SW4 (Port 8)
  		if [[ $(powerman -Q port32_7 | grep 'off:     port') ]]; then
                	sw4_output=$(echo -e "SW4 STATUS:	\e[31mOFF\e[0m")
        	elif [[ $(powerman -Q port32_7 | grep 'on:      port') ]]; then
                	sw4_output=$(echo -e "SW4 STATUS:	\e[32mON\e[0m")
        	fi
		
		echo -n "."
		echo
		
	elif [[ "$PODCHECK" == "$POD2" ]]; then
        	clear
        	echo -n "Querying power status"
        	
        	# Pod2 R1 (Port 9)
	        if [[ $(powerman -Q port32_8 | grep 'off:     port') ]]; then
        	        r1_output=$(echo -e "R1 STATUS:	\e[31mOFF\e[0m")
       		elif [[ $(powerman -Q port32_8 | grep 'on:      port') ]]; then
                	r1_output=$(echo -e "R1 STATUS:	\e[32mON\e[0m")
        	fi
		
		echo -n "."
		
		# Pod2 R2 (Port 10)
                if [[ $(powerman -Q port32_9 | grep 'off:     port') ]]; then
                        r2_output=$(echo -e "R2 STATUS:	\e[31mOFF\e[0m")
                elif [[ $(powerman -Q port32_9 | grep 'on:      port') ]]; then
                        r2_output=$(echo -e "R2 STATUS:	\e[32mON\e[0m")
                fi
		
		echo -n "."
		
		# Pod2 R3 (Port 11)
                if [[ $(powerman -Q port32_10 | grep 'off:     port') ]]; then
                        r3_output=$(echo -e "R3 STATUS:	\e[31mOFF\e[0m")
                elif [[ $(powerman -Q port32_10 | grep 'on:      port') ]]; then
                        r3_output=$(echo -e "R3 STATUS:	\e[32mON\e[0m")
                fi
		
		echo -n "."
		
		# Pod2 R4 (Port 12)
                if [[ $(powerman -Q port32_11 | grep 'off:     port') ]]; then
                        r4_output=$(echo -e "R4 STATUS:	\e[31mOFF\e[0m")
                elif [[ $(powerman -Q port32_11 | grep 'on:      port') ]]; then
                        r4_output=$(echo -e "R4 STATUS:	\e[32mON\e[0m")
                fi
		
		echo -n "."
		
		# Pod2 SW1 (Port 13)
                if [[ $(powerman -Q port32_12 | grep 'off:     port') ]]; then
                        sw1_output=$(echo -e "SW1 STATUS:	\e[31mOFF\e[0m")
                elif [[ $(powerman -Q port32_12 | grep 'on:      port') ]]; then
                        sw1_output=$(echo -e "SW1 STATUS:	\e[32mON\e[0m")
                fi
		
		echo -n "."
		
		# Pod2 SW2 (Port 14)
                if [[ $(powerman -Q port32_13 | grep 'off:     port') ]]; then
                        sw2_output=$(echo -e "SW2 STATUS:	\e[31mOFF\e[0m")
                elif [[ $(powerman -Q port32_13 | grep 'on:      port') ]]; then
                        sw2_output=$(echo -e "SW2 STATUS:	\e[32mON\e[0m")
                fi
		
		echo -n "."
		
		# Pod2 SW3 (Port 15)
                if [[ $(powerman -Q port32_14 | grep 'off:     port') ]]; then
                        sw3_output=$(echo -e "SW3 STATUS:	\e[31mOFF\e[0m")
                elif [[ $(powerman -Q port32_14 | grep 'on:      port') ]]; then
                        sw3_output=$(echo -e "SW3 STATUS:	\e[32mON\e[0m")
                fi
		
		echo -n "."
		
		# Pod2 R1 (Port 9)
                if [[ $(powerman -Q port32_15 | grep 'off:     port') ]]; then
                        sw4_output=$(echo -e "SW4 STATUS:	\e[31mOFF\e[0m")
                elif [[ $(powerman -Q port32_15 | grep 'on:      port') ]]; then
                        sw4_output=$(echo -e "SW4 STATUS:	\e[32mON\e[0m")
                fi
                
                echo -n "."
                echo
        else
        	echo "ERROR: User not in any groups. How did you get here?"
	fi
}

# Function for displaying current power states. Pulls the variables from
# powerQuery() and outputs them all at once. Without this function, the 
# powerman queries display one at a time rather than all at once.
powerStatusDisplay() {
	powerQuery
	if [[ "$PODCHECK" == "$POD1" ]]; then
		podNo=$(echo "POD 11 POWER STATUS")
	elif [[ "$PODCHECK" == "$POD2" ]]; then
		podNo=$(echo "POD 12 POWER STATUS")
	fi
	
	echo -e "
  [#####################################]
  |					|
  |      --[\e[1;38;5;27;48;5;45m$podNo\e[0m]--  	|  	
  |					|
  | 	    $r1_output		|
  | 	    $r2_output		| 
  | 	    $r3_output		|
  | 	    $r4_output		|
  |	    $sw1_output		|
  | 	    $sw2_output		|
  | 	    $sw3_output		|
  | 	    $sw4_output		|
  |      	                        |
  [#####################################]
"      
}

# Changes an individual device's power state, either to OFF or ON, depending on the
# current state of the device.
DevicePowerStateChange() {
	select choice in "R1" "R2" "R3" "R4" "SW1" "SW2" "SW3" "SW4" "Main menu"; do
	if [[ "$PODCHECK" == "$POD1" ]]; then	
		case $REPLY in
		1)	if [[ $(powerman -Q port32_0 | grep 'on:      port') ]]; then
				powerman -0 port32_0
			elif [[ $(powerman -Q port32_0 | grep 'off:     port') ]]; then
				powerman -1 port32_0
			fi;;
	
		2)	if [[ $(powerman -Q port32_1 | grep 'on:      port') ]]; then
				 powerman -0 port32_1
                	elif [[ $(powerman -Q port32_1 | grep 'off:     port') ]]; then
                        	powerman -1 port32_1
                	fi;;
	
                3)	if [[ $(powerman -Q port32_2 | grep 'on:      port') ]]; then
                        	powerman -0 port32_2
               		elif [[ $(powerman -Q port32_2 | grep 'off:     port') ]]; then
                        	powerman -1 port32_2
                	fi;;

                4)	if [[ $(powerman -Q port32_3 | grep 'on:      port') ]]; then
                        	powerman -0 port32_3
                	elif [[ $(powerman -Q port32_3 | grep 'off:     port') ]]; then
                        	powerman -1 port32_3
        		fi;;
	
                5)	if [[ $(powerman -Q port32_4 | grep 'on:      port') ]]; then
                        	powerman -0 port32_4
                	elif [[ $(powerman -Q port32_4 | grep 'off:     port') ]]; then
                        	powerman -1 port32_4
                	fi;;

                6)	if [[ $(powerman -Q port32_5 | grep 'on:      port') ]]; then
                        	powerman -0 port32_5
                	elif [[ $(powerman -Q port32_5 | grep 'off:     port') ]]; then
                        	powerman -1 port32_5
			fi;;
			
                7)	if [[ $(powerman -Q port32_6 | grep 'on:      port') ]]; then
                        	powerman -0 port32_6
                	elif [[ $(powerman -Q port32_6 | grep 'off:     port') ]]; then
                        	powerman -1 port32_6
	                fi;;

                8)	if [[ $(powerman -Q port32_7 | grep 'on:      port') ]]; then
                        	powerman -0 port32_7
                	elif [[ $(powerman -Q port32_7 | grep 'off:     port') ]]; then
                        	powerman -1 port32_7
                	fi;;
		
		9) clear
		powerStatusDisplay
		break;;

		*) echo "Incorrect input, try again.";;

		esac

	elif [[ "$PODCHECK" == "$POD2" ]]; then
                case $REPLY in
                1)      if [[ $(powerman -Q port32_8 | grep 'on:      port') ]]; then
                                powerman -0 port32_8
                        elif [[ $(powerman -Q port32_8 | grep 'off:     port') ]]; then
                                powerman -1 port32_8
                        fi;;

                2)      if [[ $(powerman -Q port32_9 | grep 'on:      port') ]]; then
                                 powerman -0 port32_9
                        elif [[ $(powerman -Q port32_9 | grep 'off:     port') ]]; then
                                powerman -1 port32_9
                        fi;;

                3)      if [[ $(powerman -Q port32_10 | grep 'on:      port') ]]; then
                                powerman -0 port32_10
                        elif [[ $(powerman -Q port32_10 | grep 'off:     port') ]]; then
                                powerman -1 port32_10
                        fi;;

                4)      if [[ $(powerman -Q port32_11 | grep 'on:      port') ]]; then
                                powerman -0 port32_11
                        elif [[ $(powerman -Q port32_11 | grep 'off:     port') ]]; then
                                powerman -1 port32_11
                        fi;;

                5)      if [[ $(powerman -Q port32_12 | grep 'on:      port') ]]; then
                                powerman -0 port32_12
                        elif [[ $(powerman -Q port32_12 | grep 'off:     port') ]]; then
                                powerman -1 port32_12
                        fi;;

                6)      if [[ $(powerman -Q port32_13 | grep 'on:      port') ]]; then
                                powerman -0 port32_13
                        elif [[ $(powerman -Q port32_13 | grep 'off:     port') ]]; then
                                powerman -1 port32_13
                        fi;;

                7)      if [[ $(powerman -Q port32_14 | grep 'on:      port') ]]; then
                                powerman -0 port32_14
                        elif [[ $(powerman -Q port32_14 | grep 'off:     port') ]]; then
                                powerman -1 port32_14
                        fi;;

                8)      if [[ $(powerman -Q port32_15 | grep 'on:      port') ]]; then
                                powerman -0 port32_15
                        elif [[ $(powerman -Q port32_15 | grep 'off:     port') ]]; then
                                powerman -1 port32_15
                        fi;;

                9) clear
		powerStatusDisplay
                break;;

                *) echo "Incorrect input, try again.";;

                esac
	fi
	done
}

allDevicesOff() {
	read -p "Are you sure you want to shut off all devices? (Y/N): " -r -n 1 choice
	if [[ "$PODCHECK" == "$POD1" ]]; then
		case "$choice" in
			y|Y ) echo
			powerman -0 port32_[0-7]
			sleep 1
			powerStatusDisplay;;
			
			n|N ) ;;
			
			* ) echo; echo "ERROR: Enter Y or N."
				continue;;
		esac
	elif [[ "$PODCHECK" == "$POD2" ]]; then
		case "$choice" in
                        y|Y ) echo
                        powerman -0 port32_[8-15]
                        sleep 1
                        powerStatusDisplay;;

                        n|N ) ;;

                        * ) echo; echo "ERROR: Enter Y or N."
                                continue;;
                esac
	fi
}

allDevicesOn() {
	read -p "Are you sure you want to turn on all devices? (Y/N): " -n 1 -r choice
        if [[ "$PODCHECK" == "$POD1" ]]; then	
        	case "$choice" in
                	y|Y ) echo
                       	powerman -1 port32_[0-7]
                       	sleep 1
                       	powerStatusDisplay;;

                        n|N ) ;;

                        * ) echo; echo "ERROR: Enter Y or N."
                                continue;;
                esac
	elif [[ "$PODCHECK" == "$POD2" ]]; then
		case "$choice" in
                        y|Y ) echo
                        powerman -1 port32_[8-15]
                        sleep 1
                        powerStatusDisplay;;

                        n|N ) ;;

                        * ) echo; echo "ERROR: Enter Y or N."
                                continue;;
                esac
	fi
}

powerStatusDisplay
	
PS3="> "
echo "Power menu options: "
select choice in "Change device power state" "Power on all devices" "Power off all devices" "Exit"; do
case $REPLY in
	1) DevicePowerStateChange;;
	2) allDevicesOn;;
	3) allDevicesOff;;
	4) echo; break;;
esac
done
