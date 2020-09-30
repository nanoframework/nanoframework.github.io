# ESP32 Pin out

ESP32 Pin out differ depending of the physical hardware. What is common is the GPIO numbering. So refer to the documentation of your specific board to find out the physical relation. 

You can find all the details in [this file](https://github.com/nanoframework/nf-interpreter/blob/develop/targets/FreeRTOS_ESP32/ESP32_WROOM_32/common/Esp32_DeviceMapping.cpp)

## I2C

There are 2 I2C bus available:

| I2C# | Data | Clock |
| --- | --- | ---|
| I2C1 | GPIO 18 | GPIO 19 |
| I2C2 | GPIO 25 | GPIO 26 |

## SPI

There is only 1 SPI possible configuration:

| SPI# | MOSI | MISO | Clock |
| --- | --- | --- | --- |
| SPI1 | GPIO 23 | GPIO 25 | GPIO 19 |

## Serial ports

You have 1 serial port available:

| COM# | Transfer (Tx) | Reception (Rx) | RTS | CTS |
| --- | --- | --- | --- | --- |
| COM1 | GPIO 1 | GPIO 3 | GPIO 19 | GPIO 22 |

## Led PWM

There is no LED PWM on ESP32

## ADC

We use "ADC1" for 20 logical channels mapped to ESP32 controllers

| ADC# | Channel # | GPIO # | Note |
| --- | --- | --- | --- |
| ADC1 | 0 | 36 | |
| ADC1 | 1 | 37 | |
| ADC1 | 2 | 38 | |
| ADC1 | 3 | 39 | |
| ADC1 | 4 | 32 | |
| ADC1 | 5 | 33 | |
| ADC1 | 6 | 34 | |
| ADC1 | 7 | 35 | |
| ADC1 | 8 | 36 | Internal Temperture sensor (VP) |
| ADC1 | 9 | 39 | Internal Hall Sensor (VN) |
| ADC2 | 10 | 04 | |
| ADC2 | 11 | 00 | |
| ADC2 | 12 | 02 | |
| ADC2 | 13 | 15 | |
| ADC2 | 14 | 13 | |
| ADC2 | 15 | 12 | |
| ADC2 | 16 | 14 | |
| ADC2 | 17 | 27 | |
| ADC2 | 18 | 25 | |
| ADC2 | 19 | 26 | |

## DAC

2 DAC are available on the ESP32:

| DAC# | GPIO # |
| --- | --- |
| DAC1 | 25 |
| DAC2 | 26 |
