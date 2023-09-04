sudo echo 352 > /sys/class/gpio/export # USB select

sudo echo high > /sys/class/gpio/PA.04/direction

trap interrupt_func INT
interrupt_func() {
	sudo echo low > /sys/class/gpio/PA.04/direction
	sudo echo 352 > /sys/class/gpio/unexport
}

watch -n 0.1 lsusb

