#!/bin/bash

# Function to display script usage
usage() {
  echo "Usage: $0 [-s] [-c device_name] [-d device_name] [-l] [-a device_name]"
  echo "  -s: Scan for Bluetooth devices"
  echo "  -c device_name: Connect to a specific Bluetooth device"
  echo "  -d device_name: Disconnect from a specific Bluetooth device"
  echo "  -l: List connected Bluetooth devices"
  echo "  -a device_name: Switch audio output to a connected Bluetooth device"
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
  echo "Scan complete. Use -l option to see the list of discovered devices."
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

# Main script execution
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

# If no arguments provided, show usage
if [ $OPTIND -eq 1 ]; then
  usage
fi

shift $((OPTIND - 1))

echo "Script completed."
echo "For detailed audio control, you can use 'pavucontrol' (for PulseAudio) or 'wpctl' (for PipeWire)."
