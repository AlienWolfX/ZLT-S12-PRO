# ZLT-S12-PRO

A repository containing information and tools for the TOZED S12 PRO router.

> [!NOTE]
> While testing has been conducted on Philippine devices, these methods should theoretically work on all regional variants.

## Introduction

ZLT S12 is a high-performance wireless communication product developedby Guangzhou Tozed Kangwei Intelligent Technology Co., Ltd based on 4G network requirements. It is mainly used for data transmission services,equipment monitoring, wireless routing and other functions. ZLT S12 adopts high-performance processor, which can process protocol and large amount of data at high speed. It can be used with a variety of 4G CAT4 module, providing 802.11b/g/n Wi-Fi access. It also features a modified build of OpenWRT.

## Progress

Here is the current progress of the project:

- **Philippines**:
  - Tech and Superadmin account generation.
  - Telnet password generation
  - Unlocking
  - Configuration file decryption

- **Sri Lanka**:
  - Operator account generation.
  - Configuration file decryption

### User Access Levels

The device implements different user types for each country, with varying levels of access and functionality:

#### Philippines Version

1. **Web User**
   - Basic access level with limited system functionality.

2. **General User (tech)**
   - Standard web interface with additional settings tools.
   - Enhanced configuration options for advanced users.

3. **Senior User (superadmin)**
   - Full system access, including device unlocking capabilities.
   - Access to critical system functions for complete control.

#### Sri Lanka Version

1. **Web User**
   - Basic access level with limited system functionality.

2. **Operator**
   - Full system access, enabling advanced configuration and management.

>[!NOTE]
> Even with superadmin or operator account passwords, the settings displayed are still limited by the value of `TZ_WEB_OPERATOR_SHOW_HIDE_PREF`

## Unlocking for Philippines Version

Follow these steps to unlock the device:

1. **Login**: Use the tech account to log in.
2. **Download Configuration**: Download the configuration file from the device.
3. **Decrypt Configuration**: Run `sh mod.sh -d` to decrypt and extract the archive.
4. **Edit Configuration**: Open `etc/config/tozed` and replace `option TZ_SYSTEM_TELNET_ENABLE '0'` with `option TZ_SYSTEM_TELNET_ENABLE '1'`.
5. **Recompile Configuration**: Run `sh mod.sh -c` to recompile the configuration file.
6. **Upload Configuration**: Upload the modified configuration back to the device and wait for it to reboot.
7. **Enable Telnet**: Run `telnet 192.168.254.254`. Use `root` as the username and the output of `sh gen_telnet_pass.sh xxxxxxxxxxxxxxx` as the password.
8. **Access Temporary Directory**: Navigate to `/tmp` using `cd /tmp`.
9. **Download Script**: Run `wget http://{URL}/generate_config.sh` to download the script.
10. **Set Permissions**: Add execution permissions using `chmod +x generate_config.sh` and execute the script.
11. **Reset Device**: Wait for the script to finish and reset the device using the web interface (do not use the physical reset button).

## Unlocking/Operator Account for Sri Lankan Version

At the time of writing, I have been receiving emails about unlocking the Sri Lankan version of the ZLT S12 PRO. Unfortunately, I cannot assist until one of you provides a firmware dump for the Sri Lankan version of the device!

## Support and Contact

For questions, issues, or contributions:

- Email: [cruizallen2@gmail.com](mailto:cruizallen2@gmail.com)
- Issues: Use the GitHub issue tracker
- Pull Requests: Welcome for improvements

## License and Copyright

Copyright © 2025 Allen Cruiz. All rights reserved.
