#!/bin/bash

set -e

echo "=== RPi5 Safe Setup Script ==="

# 1. Check platform
arch=$(uname -m)
if [[ "$arch" != "aarch64" ]]; then
  echo "ERROR: You must be using the 64-bit OS for this to work on RPi 5."
  exit 1
fi

# 2. Add HDMI safe mode + Safe Boot flags to config.txt
CONFIG="/boot/firmware/config.txt"
echo "Updating $CONFIG..."

sudo tee -a "$CONFIG" > /dev/null <<EOF

# Force HDMI safe output
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=82
disable_overscan=1
framebuffer_width=1920
framebuffer_height=1080

# Enable Safe Mode + Boot UART for debugging
BOOT_UART=1
SAFE_MODE=1
EOF

echo "Updated config.txt"

# 3. Update EEPROM
echo "Updating EEPROM..."
sudo apt update
sudo apt install -y rpi-eeprom
sudo rpi-eeprom-update -a

# 4. Full system upgrade
echo "Upgrading all packages..."
sudo apt full-upgrade -y

# 5. Done
echo "All set. Rebooting..."
sudo reboot
