#!/bin/bash

###############################################################################    
###############################################################################
#                                                                             #
# PulseAudio Volume Control:                                                  #
# Script to control the volume of the PulseAudio server                       #
#                                                                             #
# Usage:                                                                      #
# - volume.sh plus                                                            #
# - volume.sh min                                                             #
# - volume.sh get                                                             #
# - volume.sh mute                                                            #
# - volume.sh help                                                            #
#                                                                             #
# This script was inspired by:                                                #
# http://blog.waan.name/pulseaudio-setting-volume-from-command-line           #
#                                                                             #
###############################################################################
###############################################################################

SINK_NAME="alsa_output.pci-0000_00_1b.0.analog-stereo"
VOL_MAX="0x20000"
STEPS="32" # 2^n

###############################################################################
#                                                                             #
# Volume                                                                      #
#                                                                             #
###############################################################################

VOL_STEP=$((VOL_MAX / STEPS))
VOL_NOW=`pacmd dump | grep -P "^set-sink-volume $SINK_NAME\s+" | perl -p -i -e 's/.+\s(.x.+)$/$1/'`
MUTE_STATE=`pacmd dump | grep -P "^set-sink-mute $SINK_NAME\s+" | perl -p -i -e 's/.+\s(yes|no)$/$1/'`

function volume_set() {
    VOL_NEW=$1
    if [ $(($VOL_NEW)) -lt $((0x00000)) ]; then
        VOL_NEW=$((0x00000))
    elif [ $VOL_NEW -gt $((VOL_MAX)) ]; then
        VOL_NEW=$((VOL_MAX))
    fi
    pactl set-sink-volume $SINK_NAME `printf "0x%X" $VOL_NEW`
    volume_bar
}

function volume_mute() {
    if [ $MUTE_STATE = no ]; then
        pactl set-sink-mute $SINK_NAME 1
    elif [ $MUTE_STATE = yes ]; then
        pactl set-sink-mute $SINK_NAME 0
    fi
    volume_bar
}

function volume_bar() {
    BAR=""
    if [ $MUTE_STATE = yes ]; then
        BAR="mute"
        ITERATOR=$((STEPS / 2 - 2))
        while [ $ITERATOR -gt 0 ]; do
            BAR=" ${BAR} "
            ITERATOR=$((ITERATOR - 1))
        done
    else
        DENOMINATOR=$((VOL_MAX / STEPS))
        LINES=$((VOL_NOW / DENOMINATOR))
        DOTS=$((STEPS - LINES))
        while [ $LINES -gt 0 ]; do
            BAR="${BAR}|"
            LINES=$((LINES - 1))
        done
        while [ $DOTS -gt 0 ]; do
            BAR="${BAR}."
            DOTS=$((DOTS - 1))
        done
    fi
    echo "$BAR"
}

###############################################################################
#                                                                             #
# Main                                                                        #
#                                                                             #
###############################################################################

case "$1" in
    plus)
        volume_set $((VOL_NOW + VOL_STEP))
    ;;
    minus|min)
        volume_set $((VOL_NOW - VOL_STEP))
    ;;
    get)
        volume_bar
    ;;
    mute)
        volume_mute
    ;;
    help|-h|--help)
        echo ""
        echo "Usage:"
        echo "    sh $0 [get|plus|minus|mute]"
        echo ""

        exit 0      
    ;;
esac