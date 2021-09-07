# STMicroelectronics 32F769IDISCOVERY

![stm discovery](../../images/reference-targets/stm32f769i-disco.jpg)

[Product page](http://www.st.com/en/evaluation-tools/32f769idiscovery.html)

## Connecting and powering the board

There are two USB ports on the board. For firmware flashing and debugging, use the one named "USB ST_LINK"
![image](https://user-images.githubusercontent.com/71982803/132203876-38002367-37d2-49e0-b6c4-d417352cd6a6.png)

This USB connection will also power the board. Alternatively, it supports PoE, so it may be handy when deploying in the field (although you will not be able to upload new program that way). **To enable PoE, install an appropriate jumper on CN3 header**.

## Installing drivers and ST Link

To access the board, ST Link utility from here (it will also install USB drivers):
https://www.st.com/en/development-tools/stsw-link004.html#get-software

Unfortunately, ST requires registration to download them. Fortunately, you can use any 10-minute email service to overcome that. For example, https://10minutemail.com/

## Flashing initial nanoFramework firmware

Before you can code in C#, nanoFramework runtime has to be flashed in. This is done by `nanoff` utility, which you installed in the Getting Started guide. Run this command in the Command Prompt:

`nanoff --target ST_STM32F769I_DISCOVERY --update`

This command will download the latest stable FW revision, detect the COM port and flash the board.

If it complains like this, disregard it:
![image](https://user-images.githubusercontent.com/71982803/132205447-64ad0120-7477-4a49-8a03-feefce789a57.png)

You are now ready to upload C# programs.

## User LEDs

The are three LEDs available for the user, marked LD0-LD3. Their pins are:

|Marking|STM pin|nF pin number|Alternative function|
|---|---|---|---|
|LD0|PJ13|157|-|
|LD1|PJ5|149|-|
|LD2|PA12|12|-|
|LD3|PD4|52|-|

**Note**: LD3 levels are inverted compared to LD0-LD2.

**Note**: LD2 is also tied to the Arduino header pin D13.

nF pin number is calculated like so: `portNumber * 16 + pinNumber`. For STMs, ports are numbered alphabetically, so PA=0, PB=1, PC=2 and so on. For example, PD4 corresponds to nF pin number 52, because `3 * 16 + 4 = 52`.

## Arduino headers pinout

CN11 (power delivery):

|Marking|STM pin|nF pin number|Alternative function|
|---|---|---|---|
|NC|-|-|-|
|IOREF|-|-|-|
|RESET|NRST|-|-|
|+3V3|-|-|-|
|5V|-|-|-|
|GND|-|-|-|
|GND|-|-|-|
|VIN|-|-|-|

CN14 (analog functions):

|Marking|STM pin|nF pin number|Alternative function|
|---|---|---|---|
|A0|PA6|6|Analog channel 0|
|A1|PA4|4|Analog channel 1|
|A2|PC2|34|Analog channel 2|
|A3|PF10|90|-|
|A4|PF8|88|Analog channel 4|
|A5|PF9|89|-|

CN9 (digital functions):

|Marking|STM pin|nF pin number|Alternative function|
|---|---|---|---|
|D15|PB8|24|I2C1_SCL|
|D14|PB9|25|I2C1_SDA|
|AVDD|-|-|-|
|GND|-|-|-|
|D13|PA12|12|SPI2_SCK|
|D12|PB14|30|SPI2_MISO|
|D11|PB15|31|SPI2_MOSI|
|D10|PA11|11|SPI2_CS|
|D9|PH6|118|-|
|D8|PJ4|148|-|

CN13 (digital functions):

|Marking|STM pin|nF pin number|Alternative function|
|---|---|---|---|
|D7|PJ3|147|-|
|D6|PF7|87|-|
|D5|PC8|56|-|
|D4|PJ0|144|-|
|D3|PF6|86|-|
|D2|PJ1|145|-|
|D1|PC6|38|USART6_TX|
|D0|PC7|39|USART6_RX|

## Firmware images (ready to deploy)

| Stable | Preview |
|---|---|
| [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images/raw/ST_STM32F769I_DISCOVERY/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images/packages/detail/raw/ST_STM32F769I_DISCOVERY/latest/) | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images-dev/raw/ST_STM32F769I_DISCOVERY/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images-dev/packages/detail/raw/ST_STM32F769I_DISCOVERY/latest/) |
