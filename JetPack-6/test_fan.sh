#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

PWM_FAN_PATH=""

function find_pwmfan_path {
	for hwmon_name in $(ls /sys/class/hwmon/hwmon*/name); do
		if [[ $(cat $hwmon_name) == "pwmfan" ]]; then
			hwmon_path=$(dirname $hwmon_name)
			PWM_FAN_PATH=$(ls -1t $hwmon_path/pwm* | head -1)
		fi
	done

	if [[ $PWM_FAN_PATH == "" ]]; then
		echo "Unable to find pwmfan"
		exit 1
	fi
}

if [ -f /etc/systemd/system/nvfancontrol.service ]; then
	#echo "nvfancontrol.service found"

	find_pwmfan_path
	echo "Fan PWM value: $(cat $PWM_FAN_PATH)"

	# stop nvfancontrol service
	if [[ $(systemctl is-active nvfancontrol) == "active" ]]; then
		#echo "service active"
		systemctl stop nvfancontrol
	fi

	# double-check the nvfancontrol service stopped
	if [[ $(systemctl is-active nvfancontrol) == "active" ]]; then
		#echo "service active"
		echo "Unable to stop the service"
		exit 1
	else
		#echo "service inactive"
		echo "Starting fan test..."
		echo ""

		# test the fan manually
		echo 255 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 255 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 255 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 255 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 255 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1

		echo 0 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 0 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 0 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 0 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 0 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1

		echo 255 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 255 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 255 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 255 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 255 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1

		echo 0 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 0 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 0 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 0 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1
		echo 0 > $PWM_FAN_PATH
		echo "Fan PWM value: $(cat $PWM_FAN_PATH)"
		sleep 1

		# activate the service again
		systemctl restart nvfancontrol
	fi
else
	echo "nvfancontrol.service not found"
	exit 1
fi

echo "Done."
