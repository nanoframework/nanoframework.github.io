# Working with STM32 targets

## Can I debug the native code on any STM32 board

For that to be possible you need to be able to connect to the JTAG pins on the MCU. Most of the STM32 Discovery and Nucleo boards include a ST-Link hardware that exposes the debug port.

## How to convert MCU pin name to nanoFramework pin number?

nF pin number is calculated like so: `portNumber * 16 + pinNumber`. For STMs, ports are numbered alphabetically, so PA=0, PB=1, PC=2 and so on. For example, PD4 corresponds to nF pin number 52, because `3 * 16 + 4 = 52`.
