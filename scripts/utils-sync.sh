#!/bin/sh
#
# Copyright (C) 2010 Denis Roio <jaromil@nimk.nl>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or 
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# here below only auxiliary functions

get_ip() {
    echo "checking for a network address"
    IFACE=$1
    IP="`ifconfig $IFACE | grep 'inet addr'| awk '{print $2}'|cut -f2 -d:`"
    # make sure dhcp has assigned an address, else wait and retry
    while [ "$IP" = "" ]; do
	IP="`ifconfig $IFACE | grep 'inet addr'| awk '{print $2}'|cut -f2 -d:`"
	sleep 1
    done
    echo "listening on $IFACE configured with address $IP ..." 
}

get_netcat() {
    if [ -z $1 ]; then
	NC="../src/netcat -c"
	BC="../src/broadcaster"
    else
	NC="$APPROOT/bin/netcat -c"
	BC="$APPROOT/bin/broadcaster"
    fi
}

prepare_play() {
# poor man's syncstarting:
# we emulate remote control commands
#
# we could do much better if this damn Sigma SDK would be open
# but so far, so good.
    
    # go to the video from the initial menu position
    echo "r" > /tmp/ir_injection; sleep 1
    echo "r" > /tmp/ir_injection; sleep 1
    echo "r" > /tmp/ir_injection; sleep 2
}

switch_output() {

    type=$1
    case $type in
	hdmi)
	    echo "u" > /tmp/ir_injection; sleep 0.5
	    echo "r" > /tmp/ir_injection; sleep 0.5
	    echo "r" > /tmp/ir_injection; sleep 0.5
	    echo "n" > /tmp/ir_injection; sleep 0.5
	    echo "d" > /tmp/ir_injection; sleep 0.5
	    echo "d" > /tmp/ir_injection; sleep 0.5
	    # set HDMI res and color to auto
	    echo "n" > /tmp/ir_injection; sleep 0.5
	    echo "n" > /tmp/ir_injection; sleep 0.5
	    echo "n" > /tmp/ir_injection;
	    sleep 2 # wait change and confirm selection
	    echo "r" > /tmp/ir_injection; sleep 0.5
	    echo "n" > /tmp/ir_injection;
	    echo "video output switched to HDMI"
	    ;;

	composite)
	    echo "u" > /tmp/ir_injection; sleep 0.5
	    echo "r" > /tmp/ir_injection; sleep 0.5
	    echo "r" > /tmp/ir_injection; sleep 0.5
	    echo "n" > /tmp/ir_injection; sleep 0.5
	    # select composite default (PAL)
	    echo "n" > /tmp/ir_injection; sleep 0.5
	    echo "n" > /tmp/ir_injection; sleep 0.5
	    echo "video output switched to HDMI"
	    ;;

	*)
	    echo "output selected not recognized: $type"
    esac
}