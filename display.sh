#!/bin/bash

###############################################################################    
###############################################################################
#                                                                             #
# Display Detection:                                                          #
# Script to handle a display (dis)connect.                                    #
#                                                                             #
# Usage:                                                                      #
# - display.sh                                                                #
#                                                                             #
# This script can be used with udev, add the following rule to udev to        #
# automatically setup your displays when a monitor gets (dis)connected.       #
#                                                                             #
# SUBSYSTEM=="drm", ACTION=="change", RUN+="/path/to/display.sh"              #
#                                                                             #
###############################################################################
###############################################################################

export DISPLAY=:0.0                                                       
export DISPLAY_DIR="/sys/class/drm/card0-HDMI-A-1"
export XAUTHORITY=/home/kayalion/.Xauthority  

STATUS=`cat $DISPLAY_DIR/status`

if [ "${STATUS}" = disconnected ]; then
	/usr/bin/xrandr --auto
elif [ "${STATUS}" = connected ]; then                                    
    /usr/bin/xrandr --output HDMI1 --auto --right-of LVDS1               
else 
	/usr/bin/xrandr --auto                                
fi