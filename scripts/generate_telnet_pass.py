# Copyright (c) 2025 AlienWolfX
# Generates telnet password from IMEI

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

imei = "{YOUR_IMEI_HERE}"
password = generate_telnet_password(imei)
print(f"IMEI: {imei}")
print(f"Using digits: {imei[7:]}")
print(f"Generated Password: {password}")