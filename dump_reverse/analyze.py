import os
import struct
import binascii

def find_rootfs_partition(firmware_path):
    SQUASHFS_MAGIC = b'hsqs'  
    JFFS2_MAGIC = b'\x85\x19'  
    
    try:
        file_size = os.path.getsize(firmware_path)
        print(f"Firmware size: {file_size} bytes")
        
        with open(firmware_path, 'rb') as f:
            chunk_size = 4096
            offset = 0
            
            while offset < file_size:
                chunk = f.read(chunk_size)
                if not chunk:
                    break

                squash_pos = chunk.find(SQUASHFS_MAGIC)
                if squash_pos != -1:
                    abs_pos = offset + squash_pos
                    print(f"\nFound potential SquashFS signature at offset: 0x{abs_pos:08x}")

                    f.seek(abs_pos)
                    header = f.read(28)  
                    if len(header) == 28:
                        magic, inodes, mod_time, block_size = struct.unpack("<4s3I", header[:16])
                        if magic == SQUASHFS_MAGIC:
                            print(f"Confirmed SquashFS partition:")
                            print(f"Block size: {block_size}")
                            print(f"Inode count: {inodes}")
                            print(f"Last modified: {mod_time}")
                
                jffs2_pos = chunk.find(JFFS2_MAGIC)
                if jffs2_pos != -1:
                    abs_pos = offset + jffs2_pos
                    print(f"\nFound potential JFFS2 signature at offset: 0x{abs_pos:08x}")
                
                offset += len(chunk)
                
    except FileNotFoundError:
        print(f"Error: Could not find firmware file at {firmware_path}")
    except Exception as e:
        print(f"Error analyzing firmware: {str(e)}")

if __name__ == "__main__":
    firmware_path = os.path.join(os.path.dirname(__file__), "zlt_dump", "mtd3_firmware.bin")
    
    if os.path.exists(firmware_path):
        print(f"Analyzing firmware file: {firmware_path}")
        find_rootfs_partition(firmware_path)
    else:
        print(f"Firmware file not found at: {firmware_path}")