#!/bin/bash

# Function to list available disks
list_disks() {
  lsblk -nlo NAME,SIZE,MOUNTPOINT | grep -v "^loop" | awk '{print NR " - " $0}'
}

# Function to mount a disk
mount_disk() {
  local disk_name=$1
  local mount_point="/mnt/$disk_name"

  # Check filesystem type
  local fs_type=$(lsblk -nlo FSTYPE "/dev/$disk_name")

  sudo mkdir -p "$mount_point"

  if [ "$fs_type" = "ntfs" ]; then
    if command -v ntfs-3g &>/dev/null; then
      sudo ntfs-3g "/dev/$disk_name" "$mount_point"
    else
      echo "NTFS filesystem detected, but ntfs-3g is not installed."
      echo "Please install ntfs-3g using your package manager and try again."
      return 1
    fi
  else
    sudo mount "/dev/$disk_name" "$mount_point"
  fi

  if [ $? -eq 0 ]; then
    echo "Disk $disk_name mounted successfully at $mount_point"
    print_final_instructions "$mount_point"
  else
    echo "Failed to mount $disk_name"
    echo "If this is an NTFS partition, make sure ntfs-3g is installed."
    echo "You may also need to run 'sudo ntfsfix /dev/$disk_name' if the filesystem is dirty."
  fi
}
# Function to unmount a disk
unmount_disk() {
  local disk_name=$1
  local mount_point=$(lsblk -nlo MOUNTPOINT "/dev/$disk_name" | grep -v '^$')

  if [ -z "$mount_point" ]; then
    echo "Disk $disk_name is not mounted"
    return
  fi

  sudo umount "/dev/$disk_name"

  # Check if the disk is still mounted
  if mountpoint -q "$mount_point"; then
    echo "Failed to unmount $disk_name"
    echo "The disk might be in use. Close any applications using this disk and try again."
    echo "You can use 'lsof $mount_point' to see which processes are using the disk."
  else
    echo "Disk $disk_name unmounted successfully"
    if [ "$PWD" = "$mount_point" ] || [[ "$PWD" == "$mount_point"/* ]]; then
      cd
      echo "Current directory was on the unmounted disk. Changed to home directory."
    fi
    print_final_instructions "$HOME"
  fi
}
# Function to print final instructions
print_final_instructions() {
  local target_dir=$1
  echo ""
  echo "To change to the $target_dir directory, please run the following command:"
  echo "cd $target_dir"
  echo ""
  echo "You may need to run this command manually as the script cannot change your current shell's directory."
}

# clear console
clear

# test if write_my_name.sh is found and executable
#  if not found, exit with nothing
#  if found run command
if [ -x ./write_my_name.sh ]; then
  ./write_my_name.sh -n "Disk" -f standard -nfn -c cyan
fi

# Main script
echo "Choose an option:"
echo "1 - Mount"
echo "2 - Unmount"
read -p "Enter your choice (1 or 2): " choice

case $choice in
1)
  echo "Available disks:"
  list_disks
  read -p "Enter the number of the disk you want to mount: " disk_number
  disk_name=$(list_disks | sed -n "${disk_number}p" | awk '{print $3}')
  echo "mounting $disk_name"
  mount_disk "$disk_name"
  ;;
2)
  echo "Available disks:"
  list_disks
  read -p "Enter the number of the disk you want to unmount: " disk_number
  disk_name=$(list_disks | sed -n "${disk_number}p" | awk '{print $3}')
  echo "unmounting $disk_name"
  unmount_disk "$disk_name"
  ;;
*)
  echo "Invalid choice. Please run the script again and choose 1 or 2."
  exit 1
  ;;
esac
