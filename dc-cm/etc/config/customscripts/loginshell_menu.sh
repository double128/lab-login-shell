#!/bin/bash
#
# -- LOGIN SHELL MENU --
# DESCRIPTION:  A login shell for lab users to access racked devices
# DATE:         Summer 2018
# AUTHOR:       A HAL 9000 computer
#

## SOURCES #############################################################
. /etc/config/customscripts/variables
. /etc/config/customscripts/vm_menu

rackCheck       # Set the variables for this CM
variablesSSH    # Get variables to check for SSH IP addresses
traps           # Get traps
getPortNumbers  # Get the pmshell commands for each port

## MAIN ################################################################
clear

D=0
while [[ ${D} == 0 ]]; do
        clear
        graphics loginshell_menu
        read -p "  > " opt

        case $opt in
                1) ${PORT1};;
                2) ${PORT2};;
                3) ${PORT3};;
                4) ${PORT4};;
                5) ${PORT5};;
                6) ${PORT6};;
                v|V)    clear
                        startup ${POD}
                        res=$?
                        if [[ ${res} == 1 ]]; then
                                echo -e "\nThe VM server is not available right now. Please try again later."
                        else
                                optionMenu
                        fi
                ;;
# FIX LATER     p|P) ;;
                t|T)    clear
                        graphics topology
                        read -n 1 -s -r
                ;;
                x|X) D=1; break;;
                *) clear;;
        esac
done
