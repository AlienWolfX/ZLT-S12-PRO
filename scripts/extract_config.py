# Copyright (c) 2025 AlienWolfX
# Used to extract config from tozed-conf (CANNOT BE USED TO FLASH BACK) DONT FLASH THE OUTPUT FILE!!!

import os
import zlib
import struct
import sys

def extract_tozed_conf(input_file, output_file):
    try:
        print(f"Extracting config from: {input_file}")


        with open(input_file, 'rb') as f:
            f.seek(0x400)
            
            raw = f.read(32768 - 0x400)

            
            
            
            for end in range(len(raw), 0, -1):
                try:
                    zdata = raw[:end]
                    zlib.decompress(zdata)
                    break
                except zlib.error:
                    continue
            else:
                print("Could not find valid zlib block end.")
                return


            
            decompressed_data = zlib.decompress(raw[:end])
            with open(output_file, 'wb') as out:
                out.write(decompressed_data)
            print(f"Successfully extracted configuration to: {output_file}")
            print(f"Decompressed size: {len(decompressed_data)} bytes")

            try:
                print("\nFirst few lines of extracted config:")
                print(decompressed_data[:500].decode('utf-8'))
            except UnicodeDecodeError:
                print("Unable to display config content (not UTF-8)")

    except FileNotFoundError:
        print(f"Error: Could not find input file at {input_file}")
    except zlib.error as e:
        print(f"Error decompressing data: {str(e)}")
    except Exception as e:
        print(f"Error during extraction: {str(e)}")

def create_mtd7(original_mtd7, modified_config_file, output_file):
    """Creates a new MTD7 binary from modified config file"""
    try:
        print(f"Creating new MTD7 from modified config...")
        
        
        with open(original_mtd7, 'rb') as f:
            header = f.read(0x400)
            zlib_block = f.read(32768 - 0x400)

        
        with open(modified_config_file, 'r', encoding='utf-8') as f:
            config_data = f.read()

        
        try:
            original_config = zlib.decompress(zlib_block).decode('utf-8')
        except Exception as e:
            print(f"Error decompressing original zlib block: {e}")
            original_config = None

        
        if config_data == original_config:
            compressed_data = zlib_block
            print("Config unchanged: using original zlib block for exact match.")
        else:
            compressed_data = zlib.compress(config_data.encode('utf-8'))
            print("Config changed: using newly compressed data.")

            
            import hashlib
            
            check_value = hashlib.md5(compressed_data).digest()[:16]
            
            header = bytearray(header)
            header[4:20] = check_value
            print(f"Patched header with new check value: {check_value.hex()}")

        
        total_size = 0x400 + len(compressed_data)

        
        with open(output_file, 'wb') as f:
            
            f.write(header)

            
            f.write(compressed_data)

            
            if total_size < 32768:
                padding = b'\x00' * (32768 - total_size)
                f.write(padding)

        print(f"Successfully created new MTD7: {output_file}")
        print(f"Header size: 0x400 bytes")
        print(f"Compressed config size: {len(compressed_data)} bytes")
        print(f"Total file size: {os.path.getsize(output_file)} bytes")

        
        if os.path.getsize(output_file) != 32768:
            print("Warning: Generated file size is not 32KB!")
        else:
            print("Verification: File size is correct (32KB)")
            
    except Exception as e:
        print(f"Error creating MTD7: {str(e)}")

if __name__ == "__main__":
    base_dir = os.path.dirname(__file__)
    dump_dir = os.path.join("dump_reverse", "zlt_dump")
    
    
    original_mtd7 = os.path.join(dump_dir, "mtd7_tozed-conf.bin")
    modified_config = os.path.join(dump_dir, "modified_config.txt")
    output_mtd7 = os.path.join(dump_dir, "modified_mtd7.bin")
    
    
    if len(sys.argv) > 1 and sys.argv[1] == "create":
        if os.path.exists(modified_config) and os.path.exists(original_mtd7):
            create_mtd7(original_mtd7, modified_config, output_mtd7)
        else:
            print("Error: Required files not found!")
            print(f"Need both {original_mtd7} and {modified_config}")
    else:
        
        if os.path.exists(original_mtd7):
            extract_tozed_conf(original_mtd7, os.path.join(dump_dir, "extracted_config.txt"))
        else:
            print(f"Config file not found at: {original_mtd7}")