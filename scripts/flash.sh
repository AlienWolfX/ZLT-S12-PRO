# get file
echo "Downloading modified MTD7..."
wget http://192.168.2.127:6969/modified_mtd7.bin

# start flashing
echo "Unlocking MTD7..."
mtd unlock tozed-conf

echo "Erasing MTD7..."
mtd erase tozed-conf

echo "Flashing new config..."
mtd write modified_mtd7.bin tozed-conf

echo "Done!"
reboot
