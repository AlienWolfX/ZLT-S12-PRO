# Copyright (c) 2025 AlienWolfX
# Generates telnet password from IMEI

from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

def generate_telnet_password(imei):
    """
    Generates telnet password by using characters from index 7 to the end of the IMEI
    For example, if IMEI is "867792xxxxxxxx", it uses "xxxxxxxx"
    """
    relevant_digits = imei[7:]
    
    password_chars = ['0'] * 8
    accumulator = 0
    
    for i in range(8):
        digit = int(relevant_digits[i])
        
        accumulator = i + accumulator + digit
        password_chars[i] = chr((accumulator % 10) + ord('0'))
    
    return ''.join(password_chars)

def main():
    # Get IMEI from environment variable
    imei = os.getenv('DEVICE_IMEI')
    if not imei:
        print("Error: DEVICE_IMEI not found in environment variables")
        return

    password = generate_telnet_password(imei)
    print(f"IMEI: {imei}")
    print(f"Using digits: {imei[7:]}")
    print(f"Generated Password: {password}")

if __name__ == "__main__":
    main()