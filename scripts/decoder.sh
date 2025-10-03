#!/bin/bash
# Copyright (c) 2025 AlienWolfX

HEX_STRING="FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" # Display All

echo "Hex: $HEX_STRING"
echo "Binary:"

# Convert each hex digit to 4-bit binary
# ZLT uses 4-bit segments for displaying pages in the dashboard
# For example in Advanced Settings if the segments is 1001 it shows Flight Mode and Wan Settings
for (( i=0; i<${#HEX_STRING}; i++ )); do
    hex_char="${HEX_STRING:$i:1}"
    bin_char=$(printf "%04d" "$(echo "ibase=16; obase=2; $hex_char" | bc)")
    echo -n "$bin_char"
done | fold -w4 | nl
