sudo echo 446 > /sys/class/gpio/export
sudo echo 328 > /sys/class/gpio/export
sudo echo 331 > /sys/class/gpio/export
sudo echo 389 > /sys/class/gpio/export
sudo echo 433 > /sys/class/gpio/export

sudo echo high > /sys/class/gpio/PP.06/direction
sudo echo high > /sys/class/gpio/PCC.00/direction
sudo echo low > /sys/class/gpio/PCC.03/direction
sudo echo low > /sys/class/gpio/PG.06/direction
sudo echo high > /sys/class/gpio/PN.01/direction

trap interrupt_func INT
interrupt_func() {
	sudo echo 446 > /sys/class/gpio/unexport
	sudo echo 328 > /sys/class/gpio/unexport
	sudo echo 331 > /sys/class/gpio/unexport
	sudo echo 389 > /sys/class/gpio/unexport
	sudo echo 433 > /sys/class/gpio/unexport
}

watch -n 0.1 lsusb

