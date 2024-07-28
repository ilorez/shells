# shells
Hello there! This is my shells that contains some useful shell scripts.

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

