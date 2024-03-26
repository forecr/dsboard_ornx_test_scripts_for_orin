#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sudo busybox devmem 0x0c303018 w 0x458
sudo busybox devmem 0x0c303010 w 0x400

sudo modprobe can
sudo modprobe can_raw
sudo modprobe mttcan
sudo ip link set can0 up type can bitrate 500000 dbitrate 2000000 berr-reporting on fd on

trap interrupt_func INT
interrupt_func() {
	sudo ip link set can0 down
	read -p 'Press [Enter] to exit' quit_key
}

cangen can0 -v

