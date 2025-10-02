#!/bin/bash

HEX_STRING="81DFD45FFFFFFFFFF7F21FFFE2860C2BB"

echo "Hex: $HEX_STRING"
echo "Binary:"

# Convert each hex digit to 4-bit binary
for (( i=0; i<${#HEX_STRING}; i++ )); do
    hex_char="${HEX_STRING:$i:1}"
    bin_char=$(printf "%04d" "$(echo "ibase=16; obase=2; $hex_char" | bc)")
    echo -n "$bin_char"
done | fold -w4 | nl
