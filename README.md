# ZLT-S12-PRO

A repository of Information regarding TOZED S12 PRO (Philippines)

> [!NOTE]
> I haven't tested my findings yet with devices outside Philippines but in theory it should work.

## Preamble

ZLT S12 Pro is a CAT6 LTE device by SZTOZED running on a highly modified build of OpenWRT

### User Types

The device has three types of users: **Web User**, who has limited access to the system; **General User**(tech), who has the same UI as the General User but with additional tools under the settings; and **Senior User**(superadmin), who has full access to the system, including unlocking the device and other critical functionalities.

### Param file

The tozed-param file holds the critical configuration for generating password for each user and some other device settings.

#### Show Hidden Settings

> [!NOTE]
> I managed to make it permanent :D

The current Senior user is restricted to a certain level. We need to change the level to '1' for it to work. You need to find `api.lua` and edit it as follows:

```lua
elseif (userSign == 'TZ_SUPER_USERNAME') then
	tz_answer["auth"] = web_info["web_operator_show_hide_pref"]
    tz_answer["level"] = "2"
```

### Telnet Access

This section details the telnet password generation algorithm that was discovered through reverse engineering.

#### Password Generation Algorithm

The router uses a deterministic algorithm based on the device's IMEI number to generate telnet access passwords:

1. Key characteristics:
   - Uses digits from the IMEI starting at index 7
   - Processes 8 consecutive digits to generate an 8-digit password
   - Employs a rolling accumulator algorithm

2. Implementation details:

   ```python
   # For IMEI: "867792xxxxxxxxx"
   # Uses substring: "xxxxxxxxx"
   
   accumulator = 0
   for i in range(8):
       digit = int(imei[7+i])
       accumulator = i + accumulator + digit
       password[i] = (accumulator % 10) + '0'
   ```

#### Usage

A Python script (`scripts/generate_telnet_pass.py`) is provided to generate telnet passwords:

- Takes an IMEI number as input
- Extracts the relevant digits (positions 7-14)
- Applies the accumulator algorithm
- Outputs the 8-digit telnet password

#### Security Notes

- Password generation is deterministic
- Only requires knowledge of device IMEI
- No additional entropy or time-based components
- Pattern is consistent across device reboots
- IMEI must be exactly 15 digits
- Generated password is always 8 digits long

### Contact Me

Email: [cruizallen2@gmail.com](mailto:cruizallen2@gmail.com)

### Copyright

Copyright Allen Cruiz 2025
