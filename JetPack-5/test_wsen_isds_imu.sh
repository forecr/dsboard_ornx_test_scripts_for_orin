#!/bin/bash
# =============================================================================
# WSEN-ISDS (2536030320001) — IIO sysfs reader (simplified output)
#
# Usage:
#   ./test_wsen_isds_imu.sh                # auto-detect, 1s interval
#   ./test_wsen_isds_imu.sh -i 0.5         # 0.5s refresh interval
#   ./test_wsen_isds_imu.sh -d /sys/bus/iio/devices/iio:device0
#
# Press Ctrl+C to exit cleanly.
# =============================================================================

INTERVAL=1
DEV=""

while getopts "d:i:h" opt; do
    case $opt in
        d) DEV="$OPTARG" ;;
        i) INTERVAL="$OPTARG" ;;
        *) echo "Usage: $0 [-d <iio_device_path>] [-i <interval_seconds>]"; exit 1 ;;
    esac
done

cleanup() {
    tput cnorm
    echo ""
    echo "Stopped."
    exit 0
}
trap cleanup SIGINT SIGTERM

find_device() {
    for dev in /sys/bus/iio/devices/iio:device*/; do
        compat=$(tr -d '\0' < "$dev/of_node/compatible" 2>/dev/null)
        if [[ "$compat" == "we,wsen-isds-2536030320001" ]]; then
            echo "${dev%/}"
            return 0
        fi
    done
    return 1
}

if [[ -z "$DEV" ]]; then
    DEV=$(find_device)
    if [[ $? -ne 0 ]]; then
        echo "ERROR: WSEN-ISDS IIO device not found."
        exit 1
    fi
fi

DEV="${DEV%/}"

read_sysfs() {
    cat "$DEV/$1" 2>/dev/null
}

# Read static values once
ACCEL_SCALE=$(read_sysfs in_accel_scale)
GYRO_SCALE=$(read_sysfs in_anglvel_scale)
TEMP_OFFSET=$(read_sysfs in_temp_offset)
TEMP_SCALE=$(tr -d '\0' < "$DEV/in_temp_scale" 2>/dev/null)
ACCEL_ODR=$(read_sysfs in_accel_sampling_frequency)
GYRO_ODR=$(read_sysfs in_anglvel_sampling_frequency)

tput civis
SAMPLE=0

while true; do
    SAMPLE=$((SAMPLE + 1))

    ACCEL_X_RAW=$(read_sysfs in_accel_x_raw)
    ACCEL_Y_RAW=$(read_sysfs in_accel_y_raw)
    ACCEL_Z_RAW=$(read_sysfs in_accel_z_raw)

    GYRO_X_RAW=$(read_sysfs in_anglvel_x_raw)
    GYRO_Y_RAW=$(read_sysfs in_anglvel_y_raw)
    GYRO_Z_RAW=$(read_sysfs in_anglvel_z_raw)

    TEMP_RAW=$(read_sysfs in_temp_raw)

    eval "$(awk \
        -v ax="$ACCEL_X_RAW" -v ay="$ACCEL_Y_RAW" -v az="$ACCEL_Z_RAW" \
        -v as="$ACCEL_SCALE" \
        -v gx="$GYRO_X_RAW"  -v gy="$GYRO_Y_RAW"  -v gz="$GYRO_Z_RAW" \
        -v gs="$GYRO_SCALE" \
        -v tr="$TEMP_RAW"    -v to="$TEMP_OFFSET"  -v ts="$TEMP_SCALE" \
    'BEGIN {
        ax_ms2    = ax * as
        ay_ms2    = ay * as
        az_ms2    = az * as
        accel_mag = sqrt(ax_ms2^2 + ay_ms2^2 + az_ms2^2)
        gx_dps  = gx * gs * (180.0 / 3.14159265358979)
        gy_dps  = gy * gs * (180.0 / 3.14159265358979)
        gz_dps  = gz * gs * (180.0 / 3.14159265358979)
        temp_degc = ((tr + to) * ts) / 1000.0
        printf "ACCEL_X_MS2=%.4f\n",  ax_ms2
        printf "ACCEL_Y_MS2=%.4f\n",  ay_ms2
        printf "ACCEL_Z_MS2=%.4f\n",  az_ms2
        printf "ACCEL_MAG=%.4f\n",    accel_mag
        printf "GYRO_X_DPS=%.4f\n",   gx_dps
        printf "GYRO_Y_DPS=%.4f\n",   gy_dps
        printf "GYRO_Z_DPS=%.4f\n",   gz_dps
        printf "TEMP_DEGC=%.2f\n",    temp_degc
    }')"

    clear

    echo "WSEN-ISDS | Sample #$SAMPLE | Interval: ${INTERVAL}s"
    echo "--------------------------------------------"
    echo ""
    echo "  Accelerometer (ODR: ${ACCEL_ODR} Hz)"
    echo "    X: $ACCEL_X_MS2 m/s²"
    echo "    Y: $ACCEL_Y_MS2 m/s²"
    echo "    Z: $ACCEL_Z_MS2 m/s²"
    echo "    Magnitude: $ACCEL_MAG m/s²"
    echo ""
    echo "  Gyroscope (ODR: ${GYRO_ODR} Hz)"
    echo "    X: $GYRO_X_DPS deg/s"
    echo "    Y: $GYRO_Y_DPS deg/s"
    echo "    Z: $GYRO_Z_DPS deg/s"
    echo ""
    echo "  Temperature"
    echo "    $TEMP_DEGC °C"
    echo ""
    echo "--------------------------------------------"
    echo "  Press Ctrl+C to stop"

    sleep "$INTERVAL"
done
