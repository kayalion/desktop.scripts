# Desktop Scripts

This repository contains some scripts for my Linux desktop.
It's a MacBook Pro 9,2 running XFCE4 on Ubuntu 12.04.

## brightness.sh

This script implements a set of commands to change the brightness of the display and keyboard.
It uses _udev_ to perform the brightness change.

Usage:

* brightness.sh keyboard plus
* brightness.sh keyboard min
* brightness.sh keyboard set <percent>
* brightness.sh keyboard get
* brightness.sh display plus
* brightness.sh display min
* brightness.sh display set <percent>
* brightness.sh display get
* brightness.sh help

Note: To make sure you are able to write the new brightness value, add the following to _/etc/rc.local_:

    chmod 777 /sys/class/leds/smc::kbd_backlight/brightness
    chmod 777 /sys/class/backlight/intel_backlight/brightness

## display.sh

This script invokes xrandr with different parameters depending on whether a external display is connected.

Usage:

* display.sh

You can use this script with _udev_ to automatically detect connection and disconnection of an external display.
Create the file _display.rules_ in _/etc/udev/rules.d_ with the following rule:

    SUBSYSTEM=="drm", ACTION=="change", RUN+="/path/to/display.sh"

## volume.sh

This script implements a set of commands to bind the volume keyboard buttons.
It uses _pactl_ to perform the volume manipulation.

Usage:

* volume.sh plus
* volume.sh min
* volume.sh get
* volume.sh mute
* volume.sh help