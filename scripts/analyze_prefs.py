def hex_to_binary(hex_value):
    """Convert a hexadecimal string to a binary string."""
    try:
        binary_value = bin(int(hex_value, 16))[2:].zfill(len(hex_value) * 4)
        return binary_value
    except ValueError as e:
        return f"Error: {e}"

def analyze_binary(binary_value):
    """Analyze the binary string for patterns or groupings."""
    print(f"Binary Value: {binary_value}")
    print(f"Length: {len(binary_value)} bits")
    print("Grouped by 4 bits:")
    print(" ".join([binary_value[i:i+4] for i in range(0, len(binary_value), 4)]))

def enable_all_features(hex_value):
    """Enable all features by setting all bits to 1."""
    binary_length = len(hex_to_binary(hex_value))
    all_enabled_binary = '1' * binary_length
    all_enabled_hex = hex(int(all_enabled_binary, 2))[2:].upper()
    return all_enabled_hex

def generate_full_bitmask(highest_bit):
    """Generate a hexadecimal bitmask with all bits set to 1 up to the highest bit."""
    binary_mask = '1' * (highest_bit + 1)  
    hex_mask = hex(int(binary_mask, 2))[2:].upper()  
    return hex_mask

if __name__ == "__main__":
    operator_pref = "81DFD45FFFFFFFFFF7F21FFFE2860C2BB"

    print("Analyzing TZWEB_OPERATOR_SHOW_HIDE_PREF:")
    operator_binary = hex_to_binary(operator_pref)
    analyze_binary(operator_binary)

    print("\nEnabling all features for TZWEB_OPERATOR_SHOW_HIDE_PREF:")
    all_enabled_operator_pref = enable_all_features(operator_pref)
    print(f"New Hex Value: {all_enabled_operator_pref}")

    print("\nAnalyzing New TZWEB_OPERATOR_SHOW_HIDE_PREF:")
    new_operator_binary = hex_to_binary(all_enabled_operator_pref)
    analyze_binary(new_operator_binary)

    highest_bit = 153

    full_bitmask = generate_full_bitmask(highest_bit)
    print(f"Full Bitmask (Hex): {full_bitmask}")