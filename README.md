# shells
Hello there! This is my shells repo that contains some useful shell scripts.


## Table of Content
- [projector](#projector) 
- [add_user](#add_user) 
- [remove_user](#remove_user) 
- [mount_unmount_disk](#mount_unmount_disk) 
- [download_figlet_fonts](#download_figlet_fonts) 
- [write_my_name](#write_my_name) 
 
## projector

**`projector.sh`** is a versatile script for managing your projector display settings via HDMI on a Linux system.
### Requirements:
-  **`xrandr`** for setting the display configuration.

### Features:
- **Turn the projector on/off** with specified configurations.
- **Position the projector screen** relative to your laptop screen (left, right, above, under).
- **Set the projector resolution**.

### Usage:

1. **Turn on the projector (default settings):**
   ```bash
   ./projector.sh
   ```

2. **Turn off the projector:**
   ```bash
   ./projector.sh off
   ```

3. **Turn on the projector with specific position and resolution:**
   ```bash
   ./projector.sh on <position> <resolution>
   ```
   - `<position>`: `left`, `right`, `above`, `under` (default: `right`)
   - `<resolution>`: e.g., `1920x1080` (default: `auto`)

### Examples:

- **Default on:**
  ```bash
  ./projector.sh
  ```

- **Turn off:**
  ```bash
  ./projector.sh off
  ```

- **On, positioned to the left:**
  ```bash
  ./projector.sh on left
  ```

- **On, above with specific resolution:**
  ```bash
  ./projector.sh on above 1920x720
  ```

Ensure the script is executable:
```bash
chmod +x projector.sh
```

## add_user

**`add_user.sh`** is a script to create a new user on a Unix system, optionally taking a username as an argument, prompting for a password, and adding the user to the sudo group.

### Features:
- **Create a new user**: Takes a username as an argument or prompts for one if not provided.
- **Set user password**: Prompts for a password and confirms it.
- **Add user to sudo group**: Grants the new user sudo privileges.
- **Switch to new user**: Switches to the newly created user's account.

### Usage:

1. **Create a new user with specified username:**
   ```bash
   ./add_user.sh username
   ```

2. **Create a new user without specifying a username (script will prompt for it):**
   ```bash
   ./add_user.sh
   ```

Ensure the script is executable:
```bash
chmod +x add_user.sh
```
## remove_user

**`remove_user.sh`** is a script to remove a user from a Unix system, optionally taking a username as an argument or prompting for one if not provided.

### Features:
- **Remove an existing user**: Takes a username as an argument or prompts for one if not provided.
- **Delete user's home directory**: Ensures the user's home directory is also removed.

### Usage:

1. **Remove a user with specified username:**
   ```bash
   ./remove_user.sh username
   ```

2. **Remove a user without specifying a username (script will prompt for it):**
   ```bash
   ./remove_user.sh
   ```

Ensure the script is executable:
```bash
chmod +x remove_user.sh
```
Notes:
  - The script will prompt for confirmation before removing the user.
  - The script will prompt for `sudo` password when removing the user.
  - The script will remove the user's home directory and all its contents.
  - The script will not remove the user's home directory if the user is currently logged in.
  - The script will not remove the user's home directory if the user is the only user on the system.


## mount_unmount_disk
**`mount_unmount_disk.sh`** is a script to mount or unmount disks on a Unix system, providing options to select the desired disk and operation.

### Features:
- **List available disks**: Shows a list of available disks with their sizes and mount points.
- **Mount disks**: Mounts selected disk to `/mnt/<disk_name>`.
- **Unmount disks**: Safely unmounts selected disk.
- **NTFS support**: Can mount NTFS filesystems if `ntfs-3g` is installed.
- **Automatic directory change**: Changes to home directory if current directory was on an unmounted disk.

### Usage:
1. **Run the script:**
   ```bash
   ./mount_unmount_disk.sh
   ```
2. **Choose an option:**
   - `1` for mounting a disk
   - `2` for unmounting a disk
3. **Select a disk** from the displayed list by entering its number.

### Requirements:
- `sudo` privileges
- `ntfs-3g` (optional, for NTFS filesystem support)

Ensure the script is executable:
```bash
chmod +x mount_unmount_disk.sh
```
Notes: 
- The script uses `lsblk` and `udisksctl` commands to list disks and mount/unmount them, respectively.
- The script will create a directory `/mnt/<disk_name>` to mount the selected disk.
- The script will change the directory to the home directory if the current directory is on an unmounted disk.
- The script will not mount the disk if it is already mounted.
- The script will not unmount the disk if it is not mounted.


## download_figlet_fonts

**`download_figlet_fonts.sh`** is a script to ensure that figlet is installed, check and install required dependencies, and download figlet fonts in parallel if not already installed.

### Features:
- **Check and install figlet**: Ensures figlet is installed on the system.
- **Install required dependencies**: Installs `wget` and `pv` if they are not already installed.
- **Download figlet fonts**: Downloads a predefined list of figlet fonts in parallel to the specified directory.

### Usage:

1. **Run the script:**
   ```bash
   ./download_figlet_fonts.sh
   ```

2. **Specify a custom directory for fonts (optional):**
   ```bash
   ./download_figlet_fonts.sh -d /path/to/fonts
   ```

Ensure the script is executable:
```bash
chmod +x download_figlet_fonts.sh
```

## write_my_name

**`write_my_name.sh`** is a script to display a given name using figlet in a specified font or in all available fonts, with an optional color.

### Features:
- **Display name in a specified font**: Uses figlet to display the name in the chosen font.
- **Display name in all available fonts**: Loops through all installed figlet fonts and displays the name.
- **Optional color output**: Allows you to display the name in a specified color.

### Usage:

1. **Display name in a specified font and color:**
   ```bash
   ./write_my_name.sh -n "Your Name" -f "font_name" -c "color"
   ```

2. **Display name in all available fonts:**
   ```bash
   ./write_my_name.sh -n "Your Name" --all
   ```

3. **For not displaying the name of the font:**
   ```bash
   ./write_my_name.sh -n "Your Name" --no-font-name
   # or
   ./write_my_name.sh -n "Your Name" -nfn
   ```

Ensure the script is executable:
```bash
chmod +x write_my_name.sh
```

### Examples:

- **Display name in the "big" font with red color:**
  ```bash
  ./write_my_name.sh -n "Ilorez" -f "big" -c "red" -nfn
  ```

- **Display name in all available fonts with blue color:**
  ```bash
  ./write_my_name.sh -n "Ilorez" --all -c "blue"
  ```

### Notes:
- Supported colors include `black`, `red`, `green`, `yellow`, `blue`, `purple`, `cyan`, and `white`.
- The script uses `figlet` to display the name in the specified font.

## Bluetooth

**`bluetooth.sh`** is a script to manage Bluetooth connections, scan for devices, and control audio output on a Linux system.

### Features:
- **Scan for Bluetooth devices**: Discovers nearby Bluetooth devices.
- **Connect to a Bluetooth device**: Establishes a connection with a specified Bluetooth device.

### Usage:

1. **Scan for Bluetooth devices and take your choice:**
   ```bash
   ./bluetooth.sh
   ```
Ensure the script is executable:
```bash
chmod +x bluetooth.sh
```

### Notes:
- The script requires `bluetoothctl` for managing Bluetooth connections.
- For audio switching, the script uses `pactl` (PulseAudio) or `wpctl` (PipeWire) depending on your system's audio setup.
- You may need to run the script with `sudo` for some operations, depending on your system's Bluetooth permissions.
- The script will prompt for `sudo` password when needed.
- The script will not connect to a device if it is already connected.

