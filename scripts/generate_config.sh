#!/bin/sh
# Copyright (c) 2025 Allen Cruiz
# Script to sync the modified tozed_param file to the device's mtd7 partition

TOZED_PARAM_URL="URL_HERE"
TOZED_PARAM_PATH="/etc/tozed_param"
TOZED_PARAM_CHK_PATH="/etc/tozed_param.chk"
MTD_DEVICE="/dev/mtd7"
MTD_CONF="tozed-conf"

check_and_clean_existing_files() {
    local has_existing=0

    if [ -f "$TOZED_PARAM_PATH" ]; then
        echo "✅ Found existing configuration file: $TOZED_PARAM_PATH"
        echo "🗑️ Removing existing configuration file..."
        rm -f "$TOZED_PARAM_PATH"
        has_existing=1
    fi

    if [ -f "$TOZED_PARAM_CHK_PATH" ]; then
        echo "✅ Found existing CHK file: $TOZED_PARAM_CHK_PATH"
        echo "🗑️ Removing existing CHK file..."
        rm -f "$TOZED_PARAM_CHK_PATH"
        has_existing=1
    fi

    if [ $has_existing -eq 1 ]; then
        echo "🧹 Cleaned up existing files"
    fi
}

check_mtd_empty() {
    hexdump -C "$MTD_DEVICE" | head -n 1 | grep -q "ff ff ff ff"
}

check_and_clean_existing_files

echo "🔄 Downloading tozed_param..."
if ! wget -q "$TOZED_PARAM_URL" -O tozed_param; then
    echo "❌ Failed to download tozed_param from $TOZED_PARAM_URL"
    exit 1
fi

echo "📁 Placing modified configuration file..."
mv -f tozed_param "$TOZED_PARAM_PATH"

echo "🧹 Erasing existing configuration..."
if ! mtd erase "$MTD_CONF"; then
    echo "❌ Failed to erase MTD partition: $MTD_CONF"
    exit 1
fi

sleep 2

if check_mtd_empty; then
    echo "✅ MTD partition was erased successfully."
else
    echo "❌ MTD partition was not properly erased!"
    exit 1
fi

sleep 2

echo "⚙️ Applying new configuration..."
if ! cfgmgr -u "$TOZED_PARAM_PATH"; then
    echo "❌ Failed to upload configuration."
    exit 1
fi

if ! cfgmgr -b; then
    echo "❌ Failed to build configuration."
    exit 1
fi

if check_mtd_empty; then
    echo "❌ MTD partition is still empty after applying configuration!"
    exit 1
else
    echo "✅ Configuration was applied successfully."
fi

echo "🎉 Done! Please reset the device to apply changes."