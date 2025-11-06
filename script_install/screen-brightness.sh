#!/bin/bash

# Install ddcutil, just for monitor detection
sudo pacman -S ddcutil

# $ sudo ddcutil getvcp 10
# VCP code 0x10 (Brightness                    ): current value =    58, max value =   100
#
# $ sudo ddcutil setvcp 10 78
#
# $ sudo ddcutil getvcp 10
# VCP code 0x10 (Brightness                    ): current value =    78, max value =   100
