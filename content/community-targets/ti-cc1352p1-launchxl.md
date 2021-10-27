# TI CC1352P1-LAUNCHXL

![TI CC1352P1](../../images/community-targets/ti_cc1352p1_shield.jpg)

[Product page](http://www.ti.com/tool/LAUNCHXL-CC1352P)

## Features

### CC1352R  mcu

- CC3220SF single-chip wireless microcontroller
- Dual-Core Architecture:
  - User-Dedicated Application MCU Subsystem
  - Dedicated software controlled radio controller
- Powerful 48-MHz Arm® Cortex®-M4F processor
- Embedded Memory:
  - 352kB of in-system Programmable Flash
  - 256KB of ROM for protocols and library functions
  - 8KB of Cache SRAM (Alternatively available as general-purpose RAM)
  - 80KB of ultra-low leakage SRAM
- Peripherals:
  - Digital peripherals can be routed to any GPIO
  - 4× 32-bit or 8× 16-bit general-purpose timers
  - 12-Bit ADC, 200 kSamples/s, 8 channels
  - 2× comparators with internal reference DAC (1× continuous time, 1× ultra-low power)
  - Programmable current source
  - 2× UART
  - 2× SSI (SPI, MICROWIRE, TI)
  - I2C
  - I2S
  - Real-Time Clock (RTC)
  - AES 128- and 256-bit Crypto Accelerator
  - ECC and RSA Public Key Hardware Accelerator
  - SHA2 Accelerator (Full suite up to SHA-512)
  - True Random Number Generator (TRNG)
  - Capacitive sensing, up to 8 channels
  - Integrated temperature and battery monitor
- Radio section
  - Multi-band sub-1 GHz and 2.4 GHz RF transceiver compatible with Bluetooth 5 Low Energy and IEEE 802.15.4 PHY and MAC
  - Excellent receiver sensitivity:
  - –121 dBm for SimpleLink long-range mode
  - –110 dBm at 50 kbps, –105 dBm for Bluetooth 125-kbps (LE Coded PHY)
  - Output power up to +14 dBm (Sub-1 GHz) and +5 dBm (2.4 GHz) with temperature compensation
  - Suitable for systems targeting compliance with worldwide radio frequency regulations
  - ETSI EN 300 220 Receiver Category 1.5 and 2, EN 300 328, EN 303 131, EN 303 204 (Europe)
  - EN 300 440 Category 2
  - FCC CFR47 Part 15
  - ARIB STD-T108 and STD-T66
  - Wide standard support
  - Output power up to +20 dBm with temperature compensation
- Wireless protocols
  - Thread
  - Zigbee®
  - Bluetooth® 5 Low Energy
  - IEEE 802.15.4g
  - IPv6-enabled smart objects (6LoWPAN),
  - Wireless M-Bus
  - Wi-SUN®
  - KNX RF
  - proprietary systems
  - SimpleLink™ TI 15.4-Stack (Sub-1 GHz)
  - Dynamic Multiprotocol Manager (DMM)

### Launchpad board

- LaunchPad with 2.4GHz and Sub-1GHz radio for wireless applications with integrated PCB trace antenna
- Broad band antenna supports both 868 MHz ISM band for Europe and 915 MHz ISM band for US with a single board
- On-board emulator gets you started with instant code development in CCS Cloud
- Can be used with both LaunchPad kit and SmartRF™ Studio applications
- Access all I/O signals with the BoosterPack plug-in module connectors
- Compatible with LCD BoosterPack

## Firmware images (ready to deploy)

The ready to use firmware images provided include support for the class libraries and features marked bellow.

| Gpio | Spi | I2c | Pwm | Adc | Serial | Events | SWO | Networking | Large Heap |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| :heavy_check_mark: |  |  |  |  | |  | |  | |

[![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images-community-targets/raw/TI_CC1352P1_LAUNCHXL_868/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images-community-targets/packages/detail/raw/TI_CC1352P1_LAUNCHXL_868/latest/)
