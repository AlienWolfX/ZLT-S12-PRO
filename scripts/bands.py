def parse_bands(hex_value):
    """
    Parse band configuration from hex value into list of enabled bands.
    For example: "FFFFFFFF" enables all bands from 1-50
    
    Args:
        hex_value (str): Hex string representing enabled bands
    
    Returns:
        str: Space-separated string of enabled band numbers
    """
    
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

def main():
    
    test_values = [
        "FFFFFFFF", # All bands enabled
        "18008000005" # Example from tozed_param
    ]
    
    for hex_value in test_values:
        bands = parse_bands(hex_value)
        print(f"Hex value: {hex_value}")
        print(f"Enabled bands: {bands}\n")

if __name__ == "__main__":
    main()