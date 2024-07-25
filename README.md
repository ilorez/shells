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

