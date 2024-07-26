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
  read -sp "Enter the password: " password
  echo
  read -sp "Retype the password: " password_confirm
  echo

  # Ensure passwords match
  if [ "$password" != "$password_confirm" ]; then
    echo "Passwords do not match. Please try again."
    get_password
  fi
}

# Main script execution
get_username $1
get_password

# Create the user and set the password
sudo useradd -m -s /bin/bash -G sudo $username
echo "$username:$password" | sudo chpasswd

# Switch to the new user
su - $username
