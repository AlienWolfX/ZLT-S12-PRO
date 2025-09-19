#!/bin/sh
# Copyright (c) 2025 AlienWolfX
# Used to sync the modified tozed_param file to the device mtd7 partition

# Error handling
set -e  # Exit on error
trap 'echo "Error: Script failed! Please check the output above."; exit 1' ERR

# Configuration
SERVER_IP="192.168.254.126"
SERVER_PORT="8000"
CONFIG_FILE="tozed_param"
MTD_PARTITION="tozed-conf"
WAIT_TIME=2

# Helper functions
check_mtd_empty() {
    if hexdump -C /dev/mtd7 | head -n 1 | grep -q "00 00 00 00"; then
        return 0
    else
        return 1
    fi
}

# Download configuration
echo "[1/5] Downloading modified configuration..."
if ! wget "http://${SERVER_IP}:${SERVER_PORT}/${CONFIG_FILE}"; then
    echo "Error: Failed to download configuration file!"
    exit 1
fi

# Verify file exists
if [ ! -f "${CONFIG_FILE}" ]; then
    echo "Error: Configuration file not found after download!"
    exit 1
fi

# Place file
echo "[2/5] Installing configuration file..."
if ! mv "${CONFIG_FILE}" "/etc/${CONFIG_FILE}"; then
    echo "Error: Failed to move configuration file!"
    exit 1
fi

# Erase partition
echo "[3/5] Erasing configuration partition..."
if ! mtd erase "${MTD_PARTITION}"; then
    echo "Error: Failed to erase MTD partition!"
    exit 1
fi

# Wait and verify erase
echo "[4/5] Verifying partition erase..."
sleep "${WAIT_TIME}"
if ! check_mtd_empty; then
    echo "Error: MTD partition not properly erased!"
    exit 1
fi

# Apply configuration
echo "[5/5] Applying new configuration..."
if ! cfgmgr -u "${CONFIG_FILE}"; then
    echo "Error: Failed to update configuration!"
    exit 1
fi

if ! cfgmgr -b; then
    echo "Error: Failed to backup configuration!"
    exit 1
fi

# Success
echo "----------------------------------------------------------------"
echo "Success! Configuration has been updated."
echo "Please reset the device to apply changes."
echo "----------------------------------------------------------------"