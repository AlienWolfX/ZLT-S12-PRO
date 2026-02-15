# Copyright (c) 2025 Allen Cruiz
# Used to parse and generate band configuration hex values

def parse_bands(hex_value): 
    value = int(hex_value, 16)

    result = ""
    
    for band in range(50):
        
        if (band & 0x20) == 0:
            mask_high = 0
            mask_low = 1 << (band & 0x1f)
        else:
            mask_high = 1 << (band & 0x1f)
            mask_low = 0
        
        value_low = value & 0xFFFFFFFF
        value_high = value >> 32
        
        if (value_low & mask_low) != 0 or (value_high & mask_high) != 0:
            
            if result:
                result += f" {band + 1}"
            else:
                result = str(band + 1)
    
    return result

def generate_band_hex(bands):
    value = 0
    
    for band in [b-1 for b in bands]:
        if (band & 0x20) == 0:
            value |= 1 << (band & 0x1f)
        else:
            value |= 1 << (band & 0x1f) << 32
    
    return f"{value:X}"

def main():
    ENABLE_BAND_GENERATOR = False
    
    test_values = [ 
        "18008000005",
        "1FFFFFFFFFF"
    ]
    
    print("Current Band Configurations:\n")
    for hex_value in test_values:
        bands = parse_bands(hex_value)
        print(f"Hex value: {hex_value}")
        print(f"Enabled bands: {bands}\n")
    
    if ENABLE_BAND_GENERATOR:
        test_cases = [
            list(range(1, 42)),   
        ]
        
        print("Band Configuration Generator\n")
        
        for bands in test_cases:
            hex_value = generate_band_hex(bands)
            print(f"Bands to enable: {bands}")
            print(f"Hex value: {hex_value}")
            enabled = parse_bands(hex_value)
            print(f"Verification - Enabled bands: {enabled}\n")

if __name__ == "__main__":
    main()