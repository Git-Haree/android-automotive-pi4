#!/bin/bash
# =======================================================
# Android Infotainment ADB Deployment & Config Script
# Uses ADB over TCP to initialize the Pi 4 environment.
# =======================================================

if [ -z "$1" ]; then
    echo "Usage: ./adb_setup.sh <PI_IP_ADDRESS>"
    exit 1
fi

PI_IP=$1
PORT=5555
APK_DIR="./apks"

echo "Connecting to Raspberry Pi at $PI_IP:$PORT..."
adb connect $PI_IP:$PORT

# Wait for device
adb wait-for-device

echo "Connected successfully."

# Setup optimal DPI for car usage (Makes UI elements larger and touch friendly)
echo "Setting LCD Density to automotive friendly size (240 DPI)..."
adb shell wm density 240

# Check if APK directory exists and install sideloaded apps
if [ -d "$APK_DIR" ]; then
    echo "Installing applications from $APK_DIR..."
    for apk in "$APK_DIR"/*.apk; do
        if [ -f "$apk" ]; then
            echo "Installing $(basename "$apk")..."
            adb install -r "$apk"
        fi
    done
else
    echo "Warning: Directory $APK_DIR not found. Skipping APK installations."
    echo "To auto-install apps, create an 'apks' folder and place .apk files inside."
fi

# Disable screen timeout (stay on indefinitely while ignition/power is active)
echo "Disabling screen timeout..."
adb shell settings put system screen_off_timeout 2147483647

echo "Setup complete."
adb disconnect $PI_IP:$PORT
