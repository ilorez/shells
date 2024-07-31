#!/bin/bash

# Function to prompt for username if not provided as argument
get_username() {
  if [ -z "$1" ]; then
    read -p "Enter the username: " username
  else
    username=$1
  fi
}

# Function to prompt for password
get_password() {
  while true; do
    read -sp "Enter the password: " password
    echo
    read -sp "Retype the password: " password_confirm
    echo

    # Ensure passwords match
    if [ "$password" == "$password_confirm" ]; then
      break
    else
      echo "Passwords do not match. Please try again."
    fi
  done
}

echo "This script will add a new user to the system with sudo privileges."

# Main script execution
get_username $1
get_password

# Check if sudo group exists, if not create it
if ! getent group sudo >/dev/null; then
  echo "Creating sudo group..."
  sudo groupadd sudo
fi

# Create the user and set the password
sudo useradd -m -s /bin/bash -G sudo $username
if [ $? -eq 0 ]; then
  echo "$username:$password" | sudo chpasswd
  if [ $? -eq 0 ]; then
    echo "User $username has been added to the system with sudo privileges."
  else
    echo "Failed to set password for $username."
    sudo userdel -r $username
    exit 1
  fi
else
  echo "Failed to add user $username."
  exit 1
fi

# Switch to the new user
echo "Switching to the new user. Please enter the password for $username when prompted."
su - $username
