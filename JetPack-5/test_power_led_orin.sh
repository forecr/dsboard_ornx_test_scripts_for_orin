#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sleep_time=0.3

sudo echo 353 > /sys/class/gpio/export
sudo echo high > /sys/class/gpio/PA.05/direction
sudo echo 354 > /sys/class/gpio/export
sudo echo high > /sys/class/gpio/PA.06/direction
sudo echo 355 > /sys/class/gpio/export
sudo echo high > /sys/class/gpio/PA.07/direction

sleep $sleep_time

echo "POWER_LED0 OFF"
sudo echo 0 > /sys/class/gpio/PA.05/value
echo "POWER_LED1 OFF"
sudo echo 0 > /sys/class/gpio/PA.06/value
echo "POWER_LED2 OFF"
sudo echo 0 > /sys/class/gpio/PA.07/value

sleep $sleep_time

#Single Test
echo "step: 1/14"
echo "POWER_LED0 ON"
sudo echo 1 > /sys/class/gpio/PA.05/value
sleep $sleep_time

echo "step: 2/14"
echo "POWER_LED0 OFF"
sudo echo 0 > /sys/class/gpio/PA.05/value
sleep $sleep_time

echo "step: 3/14"
echo "POWER_LED1 ON"
sudo echo 1 > /sys/class/gpio/PA.06/value
sleep $sleep_time

echo "step: 4/14"
echo "POWER_LED1 OFF"
sudo echo 0 > /sys/class/gpio/PA.06/value
sleep $sleep_time

echo "step: 5/14"
echo "POWER_LED2 ON"
sudo echo 1 > /sys/class/gpio/PA.07/value
sleep $sleep_time

echo "step: 6/14"
echo "POWER_LED2 OFF"
sudo echo 0 > /sys/class/gpio/PA.07/value
sleep $sleep_time

#Double Test
echo "step: 7/14"
echo "POWER_LED0 ON"
echo "POWER_LED1 ON"
sudo echo 1 > /sys/class/gpio/PA.05/value
sudo echo 1 > /sys/class/gpio/PA.06/value
sleep $sleep_time

echo "step: 8/14"
echo "POWER_LED0 OFF"
echo "POWER_LED1 OFF"
sudo echo 0 > /sys/class/gpio/PA.05/value
sudo echo 0 > /sys/class/gpio/PA.06/value
sleep $sleep_time

echo "step: 9/14"
echo "POWER_LED1 ON"
echo "POWER_LED2 ON"
sudo echo 1 > /sys/class/gpio/PA.06/value
sudo echo 1 > /sys/class/gpio/PA.07/value
sleep $sleep_time

echo "step: 10/14"
echo "POWER_LED1 OFF"
echo "POWER_LED2 OFF"
sudo echo 0 > /sys/class/gpio/PA.06/value
sudo echo 0 > /sys/class/gpio/PA.07/value
sleep $sleep_time

echo "step: 11/14"
echo "POWER_LED0 ON"
echo "POWER_LED2 ON"
sudo echo 1 > /sys/class/gpio/PA.05/value
sudo echo 1 > /sys/class/gpio/PA.07/value
sleep $sleep_time

echo "step: 12/14"
echo "POWER_LED0 OFF"
echo "POWER_LED2 OFF"
sudo echo 0 > /sys/class/gpio/PA.05/value
sudo echo 0 > /sys/class/gpio/PA.07/value
sleep $sleep_time

#Triple Test
echo "step: 13/14"
echo "POWER_LED0 ON"
echo "POWER_LED1 ON"
echo "POWER_LED2 ON"
sudo echo 1 > /sys/class/gpio/PA.05/value
sudo echo 1 > /sys/class/gpio/PA.06/value
sudo echo 1 > /sys/class/gpio/PA.07/value
sleep $sleep_time

echo "step: 14/14"
echo "POWER_LED0 OFF"
echo "POWER_LED1 OFF"
echo "POWER_LED2 OFF"
sudo echo 0 > /sys/class/gpio/PA.05/value
sudo echo 0 > /sys/class/gpio/PA.06/value
sudo echo 0 > /sys/class/gpio/PA.07/value
sleep $sleep_time

echo "Completed"

sleep 1
sudo echo 1 > /sys/class/gpio/PA.05/value
sudo echo 1 > /sys/class/gpio/PA.06/value
sudo echo 1 > /sys/class/gpio/PA.07/value
sleep 1

sudo echo 353 > /sys/class/gpio/unexport
sudo echo 354 > /sys/class/gpio/unexport
sudo echo 355 > /sys/class/gpio/unexport

