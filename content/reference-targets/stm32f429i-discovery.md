# STMicroelectronics 32F429IDISCOVERY

![stm discovery](../../images/reference-targets/stm32f429i-disco.jpg)

[Product page](https://www.st.com/en/evaluation-tools/32f429idiscovery.html)

## Features

- STM32F429ZIT6 mcu
- 2 Mbytes of internal Flash memory
- 256 Kbytes of internal RAM
- 64-Mbit SDRAM (provided as 8 Mbytes of managed heap)
- 2.4" QVGA TFT LCD
- Two user LEDs: LD3 (green), LD4 (red)
- Two push-buttons (user and reset)
- USB OTG with micro-AB connector
- Simple extension header exposing most of the mcu pins
- On-board ST-LINK/V2

## Firmware images (ready to deploy)

The ready to use firmware images provided include support for the class libraries and features marked bellow.

> **Warning:** This firmware is built for hardware version B01. If you have a board with the new revision E01, the device won't be recognized.

| Gpio | Spi | I2c | Pwm | Adc | Serial | Events | SWO | Networking | Large Heap |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | | :heavy_check_mark: |

[![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images/raw/ST_STM32F429I_DISCOVERY/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images/packages/detail/raw/ST_STM32F429I_DISCOVERY/latest/)
