#!/bin/sh
# Copyright (c) 2025 AlienWolfX
# Used to sync the modified tozed_param file to the device mtd7 partition

# get file
echo "Downloading modified firmware..."
wget http://{IP}:8000/tozed_param

# place file
echo "Placing modified configuration file..."
mv tozed_param etc/tozed_param

# running cfg generation tool
echo "Generating configuration..."
mtd erase tozed-conf
cfgmgr -u tozed_param
cfgmgr -b

echo "Done! Please reset the device to apply changes."