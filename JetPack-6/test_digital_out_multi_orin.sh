#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sleep_time=0.3


echo "DIGITAL_OUT0 OFF"
gpioset --mode=signal `gpiofind "PY.02"`=0 &
PID_OUT0=$!
echo "DIGITAL_OUT1 OFF"
gpioset --mode=signal `gpiofind "PY.03"`=0 &
PID_OUT1=$!
sleep $sleep_time

#Single Test
echo "step: 1/6"
echo "DIGITAL_OUT0 ON"
kill $PID_OUT0
gpioset --mode=signal `gpiofind "PY.02"`=1 &
PID_OUT0=$!
sleep $sleep_time

echo "step: 2/6"
echo "DIGITAL_OUT0 OFF"
kill $PID_OUT0
gpioset --mode=signal `gpiofind "PY.02"`=0 &
PID_OUT0=$!
sleep $sleep_time

echo "step: 3/6"
echo "DIGITAL_OUT1 ON"
kill $PID_OUT1
gpioset --mode=signal `gpiofind "PY.03"`=1 &
PID_OUT1=$!
sleep $sleep_time

echo "step: 4/6"
echo "DIGITAL_OUT1 OFF"
kill $PID_OUT1
gpioset --mode=signal `gpiofind "PY.03"`=0 &
PID_OUT1=$!
sleep $sleep_time

#Double Test
echo "step: 5/6"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT1 ON"
kill $PID_OUT0
gpioset --mode=signal `gpiofind "PY.02"`=1 &
PID_OUT0=$!
kill $PID_OUT1
gpioset --mode=signal `gpiofind "PY.03"`=1 &
PID_OUT1=$!
sleep $sleep_time

echo "step: 6/6"
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT1 OFF"
kill $PID_OUT0
gpioset --mode=signal `gpiofind "PY.02"`=0 &
PID_OUT0=$!
kill $PID_OUT1
gpioset --mode=signal `gpiofind "PY.03"`=0 &
PID_OUT1=$!
sleep $sleep_time

echo "Completed"

sleep 1
kill $PID_OUT0
kill $PID_OUT1
sleep 1

