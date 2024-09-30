#!/bin/bash

# Function to display script usage
usage() {
  echo "Usage: $0 [OPTION]"
  echo "Options:"
  echo "  --help: Display this help message"
  echo "  --disconnect: Disconnect from the currently paired device"
  echo "  -s: Scan for Bluetooth devices"
  echo "  -c device_name: Connect to a specific Bluetooth device"
  echo "  -d device_name: Disconnect from a specific Bluetooth device"
  echo "  -l: List connected Bluetooth devices"
  echo "  -a device_name: Switch audio output to a connected Bluetooth device"
  echo
  echo "If no options are provided, the script will scan for devices and prompt to connect."
  exit 1
}

# Clear console
clear

# Check if write_my_name.sh exists and is executable
if [ -x ./write_my_name.sh ]; then
  ./write_my_name.sh -n "BLUETOOTH" -f larry3d -nfn -c blue
fi

# Check if bluetoothctl is available
if ! command -v bluetoothctl &>/dev/null; then
  echo "bluetoothctl is not installed. Please install it and try again."
  exit 1
fi

# Function to scan for Bluetooth devices
scan_devices() {
  echo "Scanning for Bluetooth devices..."
  bluetoothctl power on
  bluetoothctl scan on &
  sleep 10
  bluetoothctl scan off
  echo "Scan complete."
}

# Function to connect to a Bluetooth device
connect_device() {
  local device_name="$1"
  echo "Attempting to connect to device: $device_name"
  if bluetoothctl connect "$device_name"; then
    echo "Connected to Bluetooth device successfully."
    bluetoothctl trust "$device_name"
  else
    echo "Failed to connect to the Bluetooth device."
    echo "You may need to pair the device first. Use 'bluetoothctl pair $device_name' to pair."
  fi
}

# Function to disconnect from a Bluetooth device
disconnect_device() {
  local device_name="$1"
  echo "Disconnecting from device: $device_name"
  if bluetoothctl disconnect "$device_name"; then
    echo "Disconnected successfully."
  else
    echo "Failed to disconnect. The device may not be connected."
  fi
}

# Function to disconnect from the currently paired device
disconnect_current() {
  local connected_device=$(bluetoothctl info | grep "Device" | cut -d " " -f 2)
  if [ -n "$connected_device" ]; then
    echo "Disconnecting from current device: $connected_device"
    disconnect_device "$connected_device"
  else
    echo "No device currently connected."
  fi
}

# Function to list connected devices
list_devices() {
  echo "Connected Bluetooth devices:"
  bluetoothctl devices Connected
}

# Function to switch audio output
switch_audio() {
  local device_name="$1"
  if command -v pactl &>/dev/null; then
    # Using PulseAudio
    sink=$(pactl list short sinks | grep "$device_name" | cut -f1)
    if [ -n "$sink" ]; then
      pactl set-default-sink "$sink"
      echo "Audio output switched to $device_name"
    else
      echo "Device $device_name not found or not an audio sink"
    fi
  elif command -v wpctl &>/dev/null; then
    # Using PipeWire
    sink=$(wpctl status | grep "$device_name" | awk '{print $2}')
    if [ -n "$sink" ]; then
      wpctl set-default "$sink"
      echo "Audio output switched to $device_name"
    else
      echo "Device $device_name not found or not an audio sink"
    fi
  else
    echo "Neither PulseAudio nor PipeWire found. Unable to switch audio output."
  fi
}

# Function to scan and prompt for connection
scan_and_connect() {
  scan_devices
  echo "Available devices:"
  bluetoothctl devices
  echo
  read -p "Enter the MAC address of the device you want to connect to: " device_address
  connect_device "$device_address"
}

# Main script execution
if [ "$1" = "--help" ]; then
  usage
elif [ "$1" = "--disconnect" ]; then
  disconnect_current
elif [ $# -eq 0 ]; then
  scan_and_connect
else
  while getopts "sc:d:la:" opt; do
    case ${opt} in
    s)
      scan_devices
      ;;
    c)
      connect_device "$OPTARG"
      ;;
    d)
      disconnect_device "$OPTARG"
      ;;
    l)
      list_devices
      ;;
    a)
      switch_audio "$OPTARG"
      ;;
    \?)
      usage
      ;;
    esac
  done
fi

echo "Script completed."
echo "For detailed audio control, you can use 'pavucontrol' (for PulseAudio) or 'wpctl' (for PipeWire)."
