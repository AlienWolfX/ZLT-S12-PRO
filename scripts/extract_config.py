# Copyright (c) 2025 AlienWolfX
# Used to extract config from tozed-conf - EXTRACTION ONLY

import os
import zlib
import sys

def extract_tozed_conf(input_file, output_file):
    try:
        print(f"Extracting config from: {input_file}")

        with open(input_file, 'rb') as f:
            f.seek(0x400)
            
            raw = f.read(32768 - 0x400)

            # Find the end of the valid zlib block
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

            # Decompress and save the configuration
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

if __name__ == "__main__":
    base_dir = os.path.dirname(__file__)
    dump_dir = os.path.join("dump_reverse", "zlt_dump")
    
    mtd7 = os.path.join(dump_dir, "mtd7_tozed-conf.bin")

    if os.path.exists(mtd7):
        extract_tozed_conf(mtd7, os.path.join(dump_dir, "extracted_config.txt"))
    else:
        print(f"Config file not found at: {mtd7}")