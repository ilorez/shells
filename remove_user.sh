#!/bin/bash

# Function to prompt for username if not provided as argument
get_username() {
  if [ -z "$1" ]; then
    read -p "Enter the username to remove: " username
  else
    username=$1
  fi
}

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
