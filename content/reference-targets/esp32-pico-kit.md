# Espressif ESP32 Pico Kit

![ESP32-PICO-KIT_1](https://user-images.githubusercontent.com/71982803/132640376-e0adb80c-ca7f-4f91-bece-8ba5cb77d493.png)

[Getting Started Guide](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/hw-reference/esp32/get-started-pico-kit.html)

[Datasheet](https://www.espressif.com/sites/default/files/documentation/esp32-pico-d4_datasheet_en.pdf)

[Schematic](https://dl.espressif.com/dl/schematics/esp32-pico-kit-v4.1_schematic.pdf)

## Connecting and powering the board

There is only one USB port on the board. It is used to flash and debug the board, and also powers it.

## Installing drivers

ESP32 Pico is acceessed through a Silicon Labs CP210x USB-to-serial adapter chip. Sometimes Windows installs drivers automatically. If not, download and [install them from here](https://www.silabs.com/documents/public/software/CP210x_Universal_Windows_Driver.zip). If everything goes right, ESP32 Pico Kit will present itself as new COM port:

![image](https://user-images.githubusercontent.com/71982803/132641362-eaf39b75-b619-4a42-aadf-7211890d03d5.png)

## Flashing initial nanoFramework firmware

Before you can code in C#, nanoFramework runtime has to be flashed in. This is done by `nanoff` utility, which you installed in the Getting Started guide. Replace "COMx" with the actual port of your system ("COM4" in the screenshot above) and run this command in the Command Prompt:

`nanoff --target ESP32_PICO --serialport COMx --update`

This command will download the latest stable FW revision, detect the the board and flash it. During the process, you may be asked to click BOOT button on the board, so pay attention to the console output.

You are now ready to upload C# programs.

## User LEDs and buttons

The are no user-controllable LEDs on the board, unfortunately. You may use BOOT button, though.

|Marking|MCU port&pin|nF pin number|Alternative function|
|---|---|---|---|
|BOOT|IO0|0|-|

## Headers pinout

Markings are different on top and bottom of the board. Tables below references markings that are on the bottom.

|Marking|MCU port&pin|nF pin number|Alternative function|Note|
|---|---|---|---|---|
|F_SD1|-|-|-|Connected to internal flash. Do not use.|
|F_SD3|-|-|-|Connected to internal flash. Do not use.|
|F_CLK|-|-|-|Connected to internal flash. Do not use.|
|IO21|GPIO21|21|-||
|IO22|GPIO22|22|-||
|IO19|GPIO19|19|-||
|IO23|GPIO23|23|-||
|IO18|GPIO18|18|-||
|IO5|GPIO5|5|-||
|IO10|GPIO10|10|-||
|IO9|GPIO9|9|-||
|RXD0|GPIO3|3|-|Connected to USB-serial bridge. Do not use.|
|TXD0|GPIO1|1|-|Connected to USB-serial bridge. Do not use.|
|IO35|-|-|-|Input-only|
|IO34|-|-|-|Input-only|
|IO38|GPIO38|38|-|Input-only|
|IO37|GPIO37|37|-|Input-only|
|EN|CHIP_PU|-|-||
|GND|-|-|-||
|3V3|-|-||

|Marking|MCU port&pin|nF pin number|Alternative function|Note|
|---|---|---|---|---|
|F_CS|-|-|-|Connected to internal flash. Do not use.|
|F_SD0|-|-|-|Connected to internal flash. Do not use.|
|F_SD2|-|-|-|Connected to internal flash. Do not use.|
|SVP|GPIO36|36?|-|Input-only|
|SVN|GPIO39|39?|-|Input-only|
|IO25|GPIO25|25|-||
|IO26|GPIO26|26|-||
|IO32|?|?|-||
|IO33|?|?|-||
|IO27|GPIO27|27|-||
|IO14|?||-||
|IO12|?||-||
|IO13|?||-||
|IO15|?||-||
|IO2|?||-||
|IO4|?||-||
|IO0|?||-||
|3V3|-|-||
|GND|-|-|-||
|5V|-|-|-||

## Firmware images (ready to deploy)

| Stable | Preview |
|---|---|
| [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images/raw/ESP32_PICO/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images/packages/detail/raw/ESP32_PICO/latest/) | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images-dev/raw/ESP32_PICO/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images-dev/packages/detail/raw/ESP32_PICO/latest/) |
