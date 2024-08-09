#!/bin/bash

# Function to prompt for username if not provided as argument
get_username() {
  if [ -z "$1" ]; then
    read -p "Enter the username to remove: " username
  else
    username=$1
  fi
}
# clear console
clear

# test if write_my_name.sh is found and executable
#  if not found, exit with nothing
#  if found run command
if [ -x ./write_my_name.sh ]; then
  ./write_my_name.sh -n "remove user" -f standard -nfn -c red
fi

# Main script execution
get_username $1

# Check if the user exists
if id "$username" &>/dev/null; then
  # Remove the user and their home directory
  sudo userdel -r $username
  echo "User $username has been removed along with their home directory."
else
  echo "User $username does not exist."
fi
