import os
import sys

def extract_rootfs(firmware_path, output_path, offset=0x00217114):
    try:
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        
        with open(firmware_path, 'rb') as infile:
            infile.seek(offset)
            
            rootfs_data = infile.read()
            
            with open(output_path, 'wb') as outfile:
                outfile.write(rootfs_data)
                
            print(f"Successfully extracted rootfs to: {output_path}")
            print(f"Extracted size: {len(rootfs_data)} bytes")
            
    except FileNotFoundError:
        print(f"Error: Could not find firmware file at {firmware_path}")
    except Exception as e:
        print(f"Error extracting rootfs: {str(e)}")

if __name__ == "__main__":
    firmware_path = os.path.join(os.path.dirname(__file__), "zlt_dump", "mtd3_firmware.bin")
    output_path = os.path.join(os.path.dirname(__file__), "zlt_dump", "extracted_rootfs.bin")
    
    if os.path.exists(firmware_path):
        print(f"Extracting rootfs from: {firmware_path}")
        extract_rootfs(firmware_path, output_path)
    else:
        print(f"Firmware file not found at: {firmware_path}")