# ZLT-S12-PRO

A repository containing information and tools for the TOZED S12 PRO router.

> [!NOTE]
> While testing has been conducted on Philippine devices, these methods should theoretically work on all regional variants.

## Introduction

ZLT S12 is a high-performance wireless communication product developedby Guangzhou Tozed Kangwei Intelligent Technology Co., Ltd based on 4G network requirements. It is mainly used for data transmission services,equipment monitoring, wireless routing and other functions. ZLT S12 adopts high-performance processor, which can process protocol and large amount of data at high speed. It can be used with a variety of 4G CAT4 module, providing 802.11b/g/n Wi-Fi access. It also features a modified build of OpenWRT.

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

### Configuration System

The system uses a `tozed_param` file as its primary configuration store. This file contains critical settings including:

- User password generation rules
- Access control parameters
- System configuration values
- Device customization options

The configuration system consists of two main components:

1. `tozed_tool`: Handles
   - User password generation
   - Telnet access control
   - WiFi configuration
   - System parameters

2. `cfgmgr`: Manages the configuration file
   - Generates the tozed-conf partition
   - Handles encryption and compression
   - Creates backup checksums (.chk files)

## Support and Contact

For questions, issues, or contributions:

- Email: [cruizallen2@gmail.com](mailto:cruizallen2@gmail.com)
- Issues: Use the GitHub issue tracker
- Pull Requests: Welcome for improvements

## License and Copyright

Copyright © 2025 Allen Cruiz. All rights reserved.

## Unlocking/Operator Account for Sri Lankan Version

At the time of writing, I have been receiving emails about unlocking the Sri Lankan version of the ZLT S12 PRO. Unfortunately, I cannot assist until one of you provides a firmware dump for the Sri Lankan version of the device!.
