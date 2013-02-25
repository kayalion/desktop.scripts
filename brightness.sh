#!/bin/bash

###############################################################################    
###############################################################################
#                                                                             #
# MacBook Brightness Control:                                                 #
# Script to control the display and keyboard brightness of a MacBook running  #
# Ubuntu Linux.                                                                #
#                                                                             #
# Usage:                                                                      #
# - brightness.sh keyboard plus                                               #
# - brightness.sh keyboard min                                                #
# - brightness.sh keyboard set 75                                             #
# - brightness.sh keyboard get                                                #
# - brightness.sh display plus                                                #
# - brightness.sh display min                                                 #
# - brightness.sh display set 75                                              #
# - brightness.sh display get                                                 #
# - brightness.sh help                                                        #
#                                                                             #
# This script was inspired by:                                                #
# https://help.ubuntu.com/community/MacBookPro8-2/Quantal                     #
#                                                                             #
###############################################################################
###############################################################################

KEYBOARD_FILE="/sys/class/leds/smc::kbd_backlight/brightness"
KEYBOARD_MAX=100
KEYBOARD_STEPS=8

DISPLAY_FILE="/sys/class/backlight/intel_backlight/brightness"
DISPLAY_MAX=100
DISPLAY_STEPS=8

###############################################################################
#                                                                             #
# Keyboard                                                                    #
#                                                                             #
###############################################################################

function keyboard() {
	KEYBOARD_STEP=$((KEYBOARD_MAX / KEYBOARD_STEPS))
	KEYBOARD_LEVEL=`cat $KEYBOARD_FILE`
    KEYBOARD_LEVEL=$[(($KEYBOARD_LEVEL * 100) / 255)]

	case "$1" in
        plus)
            keyboard_set $((KEYBOARD_LEVEL + KEYBOARD_STEP))
        ;;
        minus|min)
            keyboard_set $((KEYBOARD_LEVEL - KEYBOARD_STEP))
        ;;
        get)
            keyboard_bar
		;;
        set)
            keyboard_set $2
		;;
	esac
}

function keyboard_set() {
	KEYBOARD_LEVEL=$1
	if [ $KEYBOARD_LEVEL -lt 0 ]; then
        KEYBOARD_LEVEL=0
	elif [ $KEYBOARD_LEVEL -gt $KEYBOARD_MAX ]; then
		KEYBOARD_LEVEL=$KEYBOARD_MAX
    fi
    echo "$[(($KEYBOARD_LEVEL * 255) / 100) % 256]" > $KEYBOARD_FILE
    keyboard_bar
}

function keyboard_bar() {
    BAR=""
    DENOMINATOR=$((KEYBOARD_MAX / KEYBOARD_STEPS))
    LINES=$((KEYBOARD_LEVEL / DENOMINATOR))
    DOTS=$((KEYBOARD_STEPS - LINES))
    while [ $LINES -gt 0 ]; do
        BAR="${BAR}|"
        LINES=$((LINES - 1))
    done
    while [ $DOTS -gt 0 ]; do
        BAR="${BAR}."
        DOTS=$((DOTS - 1))
    done
    echo "$BAR"
}

###############################################################################
#                                                                             #
# Display                                                                     #
#                                                                             #
###############################################################################

function display() {
	DISPLAY_STEP=$((DISPLAY_MAX / DISPLAY_STEPS))
	DISPLAY_LEVEL=`cat $DISPLAY_FILE`
    DISPLAY_LEVEL=$[(($DISPLAY_LEVEL * 100) / 4882)]

	case "$1" in
        plus)
        	display_set $((DISPLAY_LEVEL + DISPLAY_STEP))
        ;;
        min)
        	display_set $((DISPLAY_LEVEL - DISPLAY_STEP))
        ;;
        get)
            display_bar
		;;
        set)
            display_set $2
		;;
	esac
}

function display_set() {
	DISPLAY_LEVEL=$1
	if [ $DISPLAY_LEVEL -lt 0 ]; then
        DISPLAY_LEVEL=0
	elif [ $DISPLAY_LEVEL -gt $DISPLAY_MAX ]; then
		DISPLAY_LEVEL=$DISPLAY_MAX
    fi
	echo "$[(($DISPLAY_LEVEL * 4882) / 100) % 4883]" > $DISPLAY_FILE
    display_bar
}

function display_bar() {
    BAR=""
    DENOMINATOR=$((DISPLAY_MAX / DISPLAY_STEPS))
    LINES=$((DISPLAY_LEVEL / DENOMINATOR))
    DOTS=$((DISPLAY_STEPS - LINES))
    while [ $LINES -gt 0 ]; do
        BAR="${BAR}|"
        LINES=$((LINES - 1))
    done
    while [ $DOTS -gt 0 ]; do
        BAR="${BAR}."
        DOTS=$((DOTS - 1))
    done
    echo "$BAR"
}

###############################################################################
#                                                                             #
# Main                                                                        #
#                                                                             #
###############################################################################

case $1 in
   display)
		display $2 $3		
   ;;
   keyboard)
		keyboard $2 $3
   ;;
   help|-h|--help)
        echo ""
        echo "Usage:"
        echo "    sh $0 [display|keyboard] [get|set|plus|minus] [<percent>]"
        echo ""

        exit 0      
   ;;
esac
