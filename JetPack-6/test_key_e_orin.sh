#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

gpioset --mode=signal `gpiofind "PA.04"`=1 &
PID_M2E_USB_SELECT=$!

trap interrupt_func INT
interrupt_func() {
	kill $PID_M2E_USB_SELECT
	gpioset --mode=signal `gpiofind "PA.04"`=0 &
	PID_M2E_USB_SELECT=$!

	sleep 0.1
	kill $PID_M2E_USB_SELECT
}

watch -n 0.1 lsusb

