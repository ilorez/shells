#!/bin/bash

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

# Turn on Bluetooth if it's not already on
bluetoothctl power on

# Scan for available Bluetooth devices
echo "Scanning for Bluetooth devices..."
bluetoothctl scan on &
sleep 5
bluetoothctl scan off

# Get list of available Bluetooth devices
devices=$(bluetoothctl devices | cut -f2- -d' ')

# Display available devices with numbers
echo "Available Bluetooth devices:"
IFS=$'\n' read -r -d '' -a device_array <<<"$devices"
for i in "${!device_array[@]}"; do
  echo "$((i + 1)). ${device_array[$i]}"
done

# Prompt the user to select a device
read -p "Enter the number of the Bluetooth device you want to connect to: " device_number

# Check if the input is a valid number
if ! [[ "$device_number" =~ ^[0-9]+$ ]] || [ "$device_number" -lt 1 ] || [ "$device_number" -gt "${#device_array[@]}" ]; then
  echo "Invalid number. Exiting."
  exit 1
fi

# Get the selected device's MAC address
selected_device=$(echo "${device_array[$((device_number - 1))]}" | cut -d' ' -f1)

# Connect to the selected Bluetooth device
echo "Attempting to connect to the selected device..."
if bluetoothctl connect "$selected_device"; then
  echo "Connected to Bluetooth device successfully."
else
  echo "Failed to connect to the Bluetooth device."
  echo "You may need to pair the device first. Use 'bluetoothctl pair $selected_device' to pair."
fi

# Trust the device for future connections
echo "Trusting the device for future connections..."
bluetoothctl trust "$selected_device"

echo "Script completed."
echo "use pauvecontrol for audio control"
