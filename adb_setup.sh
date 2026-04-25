#!/bin/bash
# Initialize Android Automotive environment via ADB over TCP

if [ -z "$1" ]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

IP=$1
PORT=5555
APK_DIR="./apks"

adb connect $IP:$PORT
adb wait-for-device

adb shell wm density 240

if [ -d "$APK_DIR" ]; then
    for apk in "$APK_DIR"/*.apk; do
        [ -f "$apk" ] && adb install -r "$apk"
    done
fi

adb shell settings put system screen_off_timeout 2147483647
adb disconnect $IP:$PORT
