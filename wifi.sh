#!/bin/bash
# clear console
clear

# test if write_my_name.sh is found and executable
#  if not found, exit with nothing
#  if found run command
if [ -x ./write_my_name.sh ]; then
  ./write_my_name.sh -n "WIFI" -f larry3d -nfn -c cyan
fi

# Scan for available WiFi networks
networks=$(nmcli -t -f SSID dev wifi list | grep -v '^$')

# Display available networks with numbers
echo "Available WiFi networks:"
IFS=$'\n' read -r -d '' -a network_array <<<"$networks"
for i in "${!network_array[@]}"; do
  echo "$((i + 1)). ${network_array[$i]}"
done

# Prompt the user to select a network
read -p "Enter the number of the WiFi network you want to connect to: " network_number

# Check if the input is a valid number
if ! [[ "$network_number" =~ ^[0-9]+$ ]] || [ "$network_number" -lt 1 ] || [ "$network_number" -gt "${#network_array[@]}" ]; then
  echo "Invalid number. Exiting."
  exit 1
fi

# Get the selected network's SSID
selected_network="${network_array[$((network_number - 1))]}"

# Prompt the user for the WiFi password
read -p "Enter the password for '$selected_network': " wifi_password
echo

# Connect to the selected WiFi network
nmcli dev wifi connect "$selected_network" password "$wifi_password"

# Check if the connection was successful
if [ $? -eq 0 ]; then
  echo "Connected to '$selected_network' successfully."
else
  echo "Failed to connect to '$selected_network'."
fi
