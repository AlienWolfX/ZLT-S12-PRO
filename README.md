# ZLT-S12-PRO

> [!IMPORTANT]
> ONLY FOR GLOBE (PHILIPPINES) VERSION.

Tested on:

| Inline Soft Version | Software Version |
| ------------------: | :--------------: |
|              6.35.2 |       6.36       |

For recent firmware versions, I may need a device dump. If you have one, please send it to my email below.

## Introduction

ZLT S12 is a high-performance wireless communication product developed by Guangzhou Tozed Kangwei Intelligent Technology Co., Ltd based on 4G network requirements. It is mainly used for data transmission services, equipment monitoring, wireless routing, and other functions. ZLT S12 adopts a high-performance processor that can process protocols and handle large amounts of data at high speed. It can be used with a variety of 4G CAT4 module, providing 802.11b/g/n Wi-Fi access. It also features a modified build of OpenWRT.

## Progress

Here is the current progress of the project:

- Tech and Superadmin account generation.
- Telnet password generation
- Unlocking
- Dashboard Modification (Temporary)
- Configuration file decryption
- `rootfs` modification

### User Access Levels

The device implements different user types for each country, with varying levels of access and functionality:

1. **Web User**

   - Basic access level with limited system functionality.

2. **General User (tech)**

   - Standard web interface with additional settings tools.
   - Enhanced configuration options for advanced users.

3. **Senior User (superadmin)**
   - Full system access, including device unlocking capabilities.
   - Access to critical system functions for complete control.

> [!TIP]
> Even with superadmin or operator account passwords, the settings displayed are still limited by the value of `TZ_WEB_OPERATOR_SHOW_HIDE_PREF`

## Unlocking

Follow these steps to unlock the device:

1. **Login**: Use the `superadmin` account to log in.
2. **Download Configuration**: Download the configuration file from the device.
3. **Decrypt Configuration**: Run `sh export_config_mod.sh -d` to decrypt and extract the configuration.
4. **Edit Configuration**: Open `etc/config/tozed` and replace `option TZ_SYSTEM_TELNET_ENABLE '0'` with `option TZ_SYSTEM_TELNET_ENABLE '1'`.
5. **Recompile Configuration**: Run `sh export_config_mod.sh -c` to compress and encrypt the configuration file.
6. **Upload Configuration**: Upload the modified configuration back to the device and wait for it to reboot.
7. **Enable Telnet**: Run `telnet 192.168.254.254`. Use `root` as the username and the output of `gen_telnet_pwd -i xxxxxxxxxxxxx` as the password.
8. **Access Temporary Directory**: Navigate to `/tmp` using `cd /tmp`.
9. **Download Script**: Run `wget http://{URL}/generate_config.sh` to download the script.
10. **Set Permissions**: Add execution permissions using `chmod +x generate_config.sh` and execute the script.
11. **Reset Device**: Wait for the script to finish and reset the device using the web interface (do not use the physical reset button).

## Rootfs modification

> [!NOTE]
> Extracting and modifying the rootfs is an advanced operation. Do this on a GNU/Linux system. Always back up the original firmware and have a recovery plan — flashing a bad image can brick the device!.

> [!WARNING]
> Rootfs modification is only tested on the Philippines version of the device.

Typical workflow (high level):

1. Dump and back up the firmware partition from the device:

```bash
dd if=/dev/mtd3 of=firmware.bin bs=4M
```

2. Extract the rootfs from the firmware (use the provided helper):

```bash
python3 dump_reverse/extract_rootfs.py firmware.bin
```

3. Verify the extracted file is a SquashFS image:

```bash
file extracted_rootfs.bin   # should report: "Squashfs filesystem"
```

4. Unpack the SquashFS, make your changes, then repack it:

```bash
unsquashfs -d squashfs-root extracted_rootfs.bin # Extract
# make your modifications inside squashfs-root/
mksquashfs squashfs-root modified_rootfs.bin -comp xz # Repack
```

5. Inject the modified rootfs back into the firmware image:

```bash
python3 dump_reverse/inject_rootfs.py firmware.bin modified_rootfs.bin -o modified_firmware.bin
```

6. Flash the modified firmware to the device:

```bash
mtd write modified_firmware.bin firmware
reboot
```

## Dashboard Modification

> [!NOTE]
> Not persistent defaults back if reset

Follow these steps to modify the dashboard:

1. **Locate Web Files**: Navigate to the `scripts/web_mod/tz_www` directory, which contains the original web interface files.
2. **Make Modifications**: Edit the files in the `tz_www` folder as needed.
3. **Prepare Build**: Ensure your modified `tz_www` folder is placed in the same directory as `web_mod.sh` (located at `scripts/web_mod/`).
4. **Build Package**: Run the build script:
   ```bash
   sh web_mod.sh
   ```
5. **Upload to Device**: 
   - Log in to the device using the `superadmin` account.
   - Upload the generated ZIP file through the dashboard.
   - Wait for the device to apply changes and reboot.


## Support and Contact

For questions, issues, or contributions:

- Email: [cruizallen2@gmail.com](mailto:cruizallen2@gmail.com)
- Issues: Use the GitHub issue tracker
- Pull Requests: Welcome for improvements

## License and Copyright

Copyright © 2026 Allen Cruiz. All rights reserved.
