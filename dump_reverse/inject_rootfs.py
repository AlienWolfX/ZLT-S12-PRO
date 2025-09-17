import os
import shutil

def inject_rootfs(original_firmware, modified_rootfs, output_firmware, offset=0x00217114):
    try:
        original_size = os.path.getsize(original_firmware)
        
        shutil.copy2(original_firmware, output_firmware)
        
        with open(modified_rootfs, 'rb') as rootfs_file:
            rootfs_data = rootfs_file.read()
            
        with open(output_firmware, 'r+b') as firmware:
            firmware.seek(offset)
            firmware.write(rootfs_data)
            
            current_pos = offset + len(rootfs_data)
            padding_needed = original_size - current_pos
            
            if padding_needed > 0:
                padding = b'\xFF' * padding_needed
                firmware.write(padding)
            
            firmware.truncate(original_size)
            
        print(f"Successfully injected modified rootfs into: {output_firmware}")
        print(f"Original firmware size: {original_size} bytes")
        print(f"Modified rootfs size: {len(rootfs_data)} bytes")
        print(f"Padding added: {padding_needed} bytes")
        print(f"Final firmware size: {os.path.getsize(output_firmware)} bytes")
        
        if os.path.getsize(output_firmware) != original_size:
            print("WARNING: Final firmware size does not match original!")
            return False
            
        return True
        
    except FileNotFoundError as e:
        print(f"Error: File not found - {str(e)}")
        return False
    except Exception as e:
        print(f"Error injecting rootfs: {str(e)}")
        return False

if __name__ == "__main__":
    base_dir = os.path.dirname(__file__)
    original_firmware = os.path.join(base_dir, "zlt_dump", "mtd3_firmware.bin")
    modified_rootfs = os.path.join(base_dir, "zlt_dump", "modified_rootfs.bin")
    output_firmware = os.path.join(base_dir, "zlt_dump", "modified_firmware.bin")
    
    if not os.path.exists(original_firmware):
        print(f"Original firmware not found at: {original_firmware}")
        exit(1)
        
    if not os.path.exists(modified_rootfs):
        print(f"Modified rootfs not found at: {modified_rootfs}")
        exit(1)
    
    print("Checking original firmware...")
    original_size = os.path.getsize(original_firmware)
    print(f"Original firmware size: {original_size} bytes")
    
    print(f"\nInjecting modified rootfs into firmware...")
    if inject_rootfs(original_firmware, modified_rootfs, output_firmware):
        print("\nVerification:")
        print(f"1. Size matches original: {os.path.getsize(output_firmware) == original_size}")
        print(f"2. Rootfs starts at offset: 0x{0x00217114:08x}")
        print("\nFirmware creation completed successfully!")
    else:
        print("\nError occurred during firmware creation!")