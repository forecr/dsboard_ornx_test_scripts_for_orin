#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sleep_time=0.3

sudo echo 472 > /sys/class/gpio/export
sudo echo out > /sys/class/gpio/PY.02/direction
sudo echo 473 > /sys/class/gpio/export
sudo echo out > /sys/class/gpio/PY.03/direction

sleep $sleep_time

echo "DIGITAL_OUT0 OFF"
sudo echo 0 > /sys/class/gpio/PY.02/value
echo "DIGITAL_OUT1 OFF"
sudo echo 0 > /sys/class/gpio/PY.03/value

#Single Test
echo "step: 1/6"
echo "DIGITAL_OUT0 ON"
sudo echo 1 > /sys/class/gpio/PY.02/value
sleep $sleep_time

echo "step: 2/6"
echo "DIGITAL_OUT0 OFF"
sudo echo 0 > /sys/class/gpio/PY.02/value
sleep $sleep_time

echo "step: 3/6"
echo "DIGITAL_OUT1 ON"
sudo echo 1 > /sys/class/gpio/PY.03/value
sleep $sleep_time

echo "step: 4/6"
echo "DIGITAL_OUT1 OFF"
sudo echo 0 > /sys/class/gpio/PY.03/value
sleep $sleep_time

#Double Test
echo "step: 5/6"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT1 ON"
sudo echo 1 > /sys/class/gpio/PY.02/value
sudo echo 1 > /sys/class/gpio/PY.03/value
sleep $sleep_time

echo "step: 6/6"
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT1 OFF"
sudo echo 0 > /sys/class/gpio/PY.02/value
sudo echo 0 > /sys/class/gpio/PY.03/value
sleep $sleep_time

echo "Completed"

sleep 1
sudo echo 1 > /sys/class/gpio/PY.02/value
sudo echo 1 > /sys/class/gpio/PY.03/value
sleep 1

sudo echo 472 > /sys/class/gpio/unexport
sudo echo 473 > /sys/class/gpio/unexport

