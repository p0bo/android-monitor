# Hyprland Android Second Monitor

A Bash script that turns your Android device into a second monitor for Hyprland using `wayvnc` over USB (ADB).

## Prerequisites

**On your PC (Linux):**

- **Hyprland** (v0.35+ recommended)
- **adb** (part of `android-tools`)
- **wayvnc**
- **jq**
- **ss** (part of `iproute2`)

**On your Android Device:**

- **USB Debugging** enabled (in Developer Options).
- A **VNC Viewer** app (e.g., [AVNC](https://github.com/gujjwal00/avnc/), bVNC, or RealVNC).

## Configuration

1.  Clone this repository or download the script.
2.  Open the script and edit the variables at the top to match your setup:

```bash
MONITOR_MODE="2800x2000@60"  # Resolution of your tablet/phone
MONITOR_SCALE=1.67           # Hyprland scaling factor
ANDROID_DEVICE="OPD2203"     # Your device model string
```

> **Tip:** run `adb devices -l` to find your `ANDROID_DEVICE` model string.

### Custom Styling

Inside the `set_mode()` function, there are commented-out lines for workspace gaps and rounding. Uncomment them or add new rules if you want specific Hyprland rules applied to this monitor. For more details see [hyprctl#batch](https://wiki.hypr.land/Configuring/Using-hyprctl/#batch).

## Usage

1.  Connect your Android device via USB.
2.  Make the script executable:
    ```bash
    chmod +x android_as_monitor.sh
    ```
3.  Run the script:
    ```bash
    ./android_as_monitor.sh
    ```
4.  Open your VNC Viewer app on Android and connect to:
    - **Address:** `127.0.0.1`
    - **Port:** `5900`

## Troubleshooting

- **ADB Authorization:** If the script fails, check your Android screen for a prompt asking to "Allow USB Debugging."
- **Resolution:** If the screen looks stretched, adjust `MONITOR_MODE` to match your device's native resolution.
- **Black Screen:** Ensure you are running a `wayvnc` version compatible with your Hyprland version.
- **Other problems:** Open an issue if there are problems you don't understand, i'll try to help as much as i can.

## Similar projects

- [linux-extend-screen](https://github.com/santiagofdezg/linux-extend-screen) : Do give a read it inspired me to write this script, it's very detailed. You should reference this for stuff like wireless connection etc.
