# Raspberry Pi Pico (RP2040) pin out

The Raspberry Pi Pico has 40 pins, with 26 user-accessible GPIO pins (GP0–GP22, GP26–GP28). GPIO numbering in .NET **nanoFramework** matches the RP2040 GP numbers directly — `GpioPin pin = gpio.OpenPin(25)` opens GP25.

The official pinout diagrams are available from Raspberry Pi:

- [Pico / Pico H pinout diagram (SVG)](https://www.raspberrypi.com/documentation/microcontrollers/images/pico-pinout.svg)
- [Pico W / Pico WH pinout diagram (SVG)](https://www.raspberrypi.com/documentation/microcontrollers/images/picow-pinout.svg)

## Full pin table

| Physical Pin | GPIO | Primary function | SPI | I2C | UART | PWM | ADC |
|:---:|:---:|:---|:---|:---|:---|:---|:---|
| 1 | GP0 | GPIO | SPI0 RX | I2C0 SDA | UART0 TX | PWM0 A | |
| 2 | GP1 | GPIO | SPI0 CSn | I2C0 SCL | UART0 RX | PWM0 B | |
| 3 | GND | Ground | | | | | |
| 4 | GP2 | GPIO | SPI0 SCK | I2C1 SDA | UART0 CTS | PWM1 A | |
| 5 | GP3 | GPIO | SPI0 TX | I2C1 SCL | UART0 RTS | PWM1 B | |
| 6 | GP4 | GPIO | SPI0 RX | I2C0 SDA | UART1 TX | PWM2 A | |
| 7 | GP5 | GPIO | SPI0 CSn | I2C0 SCL | UART1 RX | PWM2 B | |
| 8 | GND | Ground | | | | | |
| 9 | GP6 | GPIO | SPI0 SCK | I2C1 SDA | UART1 CTS | PWM3 A | |
| 10 | GP7 | GPIO | SPI0 TX | I2C1 SCL | UART1 RTS | PWM3 B | |
| 11 | GP8 | GPIO | SPI1 RX | I2C0 SDA | UART1 TX | PWM4 A | |
| 12 | GP9 | GPIO | SPI1 CSn | I2C0 SCL | UART1 RX | PWM4 B | |
| 13 | GND | Ground | | | | | |
| 14 | GP10 | GPIO | SPI1 SCK | I2C1 SDA | UART1 CTS | PWM5 A | |
| 15 | GP11 | GPIO | SPI1 TX | I2C1 SCL | UART1 RTS | PWM5 B | |
| 16 | GP12 | GPIO | SPI1 RX | I2C0 SDA | UART0 TX | PWM6 A | |
| 17 | GP13 | GPIO | SPI1 CSn | I2C0 SCL | UART0 RX | PWM6 B | |
| 18 | GND | Ground | | | | | |
| 19 | GP14 | GPIO | SPI1 SCK | I2C1 SDA | UART0 CTS | PWM7 A | |
| 20 | GP15 | GPIO | SPI1 TX | I2C1 SCL | UART0 RTS | PWM7 B | |
| 21 | GP16 | GPIO | SPI0 RX | I2C0 SDA | UART0 TX | PWM0 A | |
| 22 | GP17 | GPIO | SPI0 CSn | I2C0 SCL | UART0 RX | PWM0 B | |
| 23 | GND | Ground | | | | | |
| 24 | GP18 | GPIO | SPI0 SCK | I2C1 SDA | UART0 CTS | PWM1 A | |
| 25 | GP19 | GPIO | SPI0 TX | I2C1 SCL | UART0 RTS | PWM1 B | |
| 26 | GP20 | GPIO | SPI0 RX | I2C0 SDA | UART1 TX | PWM2 A | |
| 27 | GP21 | GPIO | SPI0 CSn | I2C0 SCL | UART1 RX | PWM2 B | |
| 28 | GND | Ground | | | | | |
| 29 | GP22 | GPIO | SPI0 SCK | I2C1 SDA | UART1 CTS | PWM3 A | |
| 30 | RUN | Reset | | | | | |
| 31 | GP26 | GPIO/ADC | SPI1 SCK | I2C1 SDA | UART1 CTS | PWM5 A | ADC0 |
| 32 | GP27 | GPIO/ADC | SPI1 TX | I2C1 SCL | UART1 RTS | PWM5 B | ADC1 |
| 33 | AGND | Analogue ground | | | | | |
| 34 | GP28 | GPIO/ADC | SPI1 RX | I2C0 SDA | UART0 TX | PWM6 A | ADC2 |
| 35 | ADC_VREF | ADC reference voltage | | | | | |
| 36 | 3V3(OUT) | 3.3 V regulated output | | | | | |
| 37 | 3V3_EN | 3.3 V enable (pull low to disable) | | | | | |
| 38 | GND | Ground | | | | | |
| 39 | VSYS | 2 V – 5 V system input | | | | | |
| 40 | VBUS | 5 V USB input | | | | | |

> **Note**: GP23, GP24, GP25 and GP29 are used internally on the Pico board:
> - **GP23** — controls the on-board SMPS power save mode
> - **GP24** — VBUS sense (USB power detection) on Pico; used by the CYW43439 wireless chip on Pico W
> - **GP25** — on-board LED on Pico (on Pico W this LED is connected through the wireless chip)
> - **GP29** — used for ADC to monitor VSYS / 3 (internal measurement)

## On-board LED

| Board | LED GPIO | Notes |
|:---|:---|:---|
| Pico / Pico H | GP25 | Direct GPIO output |
| Pico W / Pico WH | WL_GPIO0 | Driven via CYW43439 wireless chip; not accessible as a standard GPIO |

## ADC

The RP2040 has a 12-bit ADC with 4 inputs available (3 external + 1 internal temperature sensor).

| ADC channel | GPIO | Notes |
|:---:|:---:|:---|
| ADC0 | GP26 | Pin 31 |
| ADC1 | GP27 | Pin 32 |
| ADC2 | GP28 | Pin 34 |
| ADC3 | — | Internal temperature sensor |

> ADC input voltage range is 0 V to 3.3 V. Do not exceed 3.3 V on ADC pins.

## PWM

The RP2040 has 8 PWM slices, each with two channels (A and B), giving 16 independent PWM outputs total. Almost every GPIO pin can be connected to a PWM channel. Pins on the same PWM slice share the same frequency.

| PWM | Channel A | Channel B |
|:---:|:---|:---|
| Slice 0 | GP0, GP16 | GP1, GP17 |
| Slice 1 | GP2, GP18 | GP3, GP19 |
| Slice 2 | GP4, GP20 | GP5, GP21 |
| Slice 3 | GP6, GP22 | GP7 |
| Slice 4 | GP8 | GP9 |
| Slice 5 | GP10, GP26 | GP11, GP27 |
| Slice 6 | GP12, GP28 | GP13 |
| Slice 7 | GP14 | GP15 |

## SPI default mapping

The RP2040 has two SPI controllers. The nanoFramework target uses the following default pin mapping:

| Bus | Clock (SCK) | MOSI (TX) | MISO (RX) | Chip Select (CSn) |
|:---:|:---:|:---:|:---:|:---:|
| SPI0 | GP18 | GP19 | GP16 | GP17 |
| SPI1 | GP10 | GP11 | GP8 | GP9 |

These defaults can vary by target build. Refer to the nf-interpreter target source for the exact configuration.

## I2C default mapping

The RP2040 has two I2C controllers. The nanoFramework target uses the following default pin mapping:

| Bus | SDA | SCL |
|:---:|:---:|:---:|
| I2C0 | GP4 | GP5 |
| I2C1 | GP6 | GP7 |

## UART default mapping

The RP2040 has two UART controllers.

| Port | TX | RX |
|:---:|:---:|:---:|
| UART0 | GP0 | GP1 |
| UART1 | GP4 | GP5 |

> **Note**: UART support is not yet included in the nanoFramework firmware for RP2040. Check the [nf-interpreter repository](https://github.com/nanoframework/nf-interpreter) for updates.

## Pico W — wireless chip pin sharing

On the Pico W, the CYW43439 wireless chip uses an SPI interface to the RP2040. The following RP2040 pins are shared with the wireless subsystem and are **not available** as user GPIO on Pico W:

| RP2040 GPIO | Usage on Pico W |
|:---:|:---|
| GP23 | Wireless power save control |
| GP24 | Wireless interrupt / data |
| GP25 | Wireless SPI data / chip-enable |
| GP29 | Wireless SPI clock / VSYS voltage monitor |
