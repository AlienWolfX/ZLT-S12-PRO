# ZLT-S12-PRO

A repository containing research and tools for the TOZED S12 PRO router (Philippines version).

> [!NOTE]
> While testing has been conducted on Philippine devices, these methods should theoretically work on all regional variants.

## Introduction

The ZLT S12 Pro is a CAT6 LTE router manufactured by SZTOZED, running on a customized OpenWRT build.

### User Access Levels

The device implements three distinct user types:

1. **Web User**
   - Basic access level with limited system functionality

2. **General User (tech)**
   - Standard web interface plus additional settings tools
   - Enhanced configuration options

3. **Senior User (superadmin)**
   - Full system access
   - Device unlocking capabilities
   - Access to critical system functions

### Configuration System

The system uses a `tozed_param` file as its primary configuration store. This file contains critical settings including:

- User password generation rules
- Access control parameters
- System configuration values
- Device customization options

Example configuration:

```lua
export TZSYSTEM_CUSTOMER_SOFT_VERSION="6.36"
export TZSYSTEM_SN_GENERATE_TYPE="0"
export TZSYSTEM_NO_UPDATE_TR069_CONFIG="0"
export TZSYSTEM_CUSTOMER_TYPE="ZLT S12 PRO"
export TZSYSTEM_CUSTOMER_SN_PREFIX="S12U"
```

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

## Access Methods

### Telnet Access

A custom password generation algorithm has been reverse engineered to enable telnet access to the device.

#### Password Generator Tool

The repository includes a Python script (`scripts/generate_telnet_pass.py`) that generates valid telnet passwords:

- Requires device IMEI as input
- Processes specific IMEI digits (positions 7-14)
- Implements the discovered algorithm
- Produces an 8-digit numeric password

## Support and Contact

For questions, issues, or contributions:

- Email: [cruizallen2@gmail.com](mailto:cruizallen2@gmail.com)
- Issues: Use the GitHub issue tracker
- Pull Requests: Welcome for improvements

## License and Copyright

Copyright © 2025 Allen Cruiz. All rights reserved.
