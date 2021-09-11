# ESP32 Pin out

ESP32 Pin out differ depending of the physical hardware. What is common is the GPIO numbering. So refer to the documentation of your specific board to find out the physical relation.

You can find all the details for the default mapping in [this file](https://github.com/nanoframework/nf-interpreter/blob/develop/targets/FreeRTOS_ESP32/ESP32_WROOM_32/common/Esp32_DeviceMapping.cpp)

The default mapping defines how the pins are configured on start up. These pins configurations can be configured/redefined using the nanoFramework.Hardware.Esp32 assembly.

## Example configuration

```csharp
// Define MOSI pin for SPI2 as GPIO 15
Configuration.SetPinFunction(15, DeviceFunction.SPI2_MOSI);
// Define LED PWM channel 1 GPIO 16
Configuration.SetPinFunction(16, DeviceFunction.PWM1);
// Redefine I2C2 data pin from GPIO 25 to GPIO 17
Configuration.SetPinFunction(17, DeviceFunction.I2C2_DATA);
```

## ESP32 Default Mapping

NP = Pin is undefined at startup

## I2C

There are 2 I2C bus available:

| I2C# | Data | Clock |
| --- | --- | ---|
| I2C1 | GPIO 18 | GPIO 19 |
| I2C2 | GPIO 25 | GPIO 26 |

## SPI

There are 2 SPI possible configurations:

| SPI# | MOSI | MISO | Clock |
| --- | --- | --- | --- |
| SPI1 | GPIO 23 | GPIO 25 | GPIO 19 |
| SPI2 | NP | NP | NP |

## Serial ports

You have 2 serial ports available, COM1 is reserved for debugging when enabled.

| COM# | Transfer (Tx) | Reception (Rx) | RTS | CTS |
| --- | --- | --- | --- | --- |
| COM1 | GPIO 1 | GPIO 3 | GPIO 19 | GPIO 22 |
| COM2 | NP | NP | NP | NP |
| COM3 | NP | NP | NP | NP |

## Led PWM channels

There are 16 LED PWM channels on ESP32
For all channels the GPIO pins are undefined at startup.

## ADC

We use "ADC1" with 20 logical channels mapped to the ESP32 internal controllers ADC1 and ADC2
There are the 18 available ESP32 channels plus the internal Temperature and Hall sensors making the 20 logical channels.

Restrictions:-
- Channels 10 to 19 can not be used while the WiFi is enabled. (exception CLR_E_PIN_UNAVAILABLE)
- Hall sensor and Temperature sensor can not be used at same time as Channels 0 and 3.
- Gpio 0, 2, 15 are strapping pins and can not be freely used ( Channels 11, 12, 13 )

| ESP32 ADC# | Channel # | GPIO # | Note |
| --- | --- | --- | --- |
| ADC1 | 0 | 36 | See restrictions|
| ADC1 | 1 | 37 | |
| ADC1 | 2 | 38 | |
| ADC1 | 3 | 39 | See restrictions |
| ADC1 | 4 | 32 | |
| ADC1 | 5 | 33 | |
| ADC1 | 6 | 34 | |
| ADC1 | 7 | 35 | |
| ADC1 | 8 | 36 | Internal Temperture sensor (VP), See restrictions |
| ADC1 | 9 | 39 | Internal Hall Sensor (VN), See restrictions |
| ADC2 | 10 | 04 | |
| ADC2 | 11 | 00 | Strapping pin |
| ADC2 | 12 | 02 | Strapping pin |
| ADC2 | 13 | 15 | Strapping pin |
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
