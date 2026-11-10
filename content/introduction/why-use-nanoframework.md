# Why use .NET **nanoFramework**

.NET **nanoFramework** is the perfect enabler for developing software that works on embedded devices. Start with a low cost and readily available development board, then use .NET **nanoFramework** to write, debug and deploy your code.

Whether this is your first foray into programming or you are a seasoned developer, if you want a powerful and easy to use tool for developing software that runs on embedded devices, you are in the right place. With its modular architecture, it’s easy to grab the core components (like the CLR, debugger and interpreter) and extend it to new hardware platforms, .NET **nanoFramework** is the perfect partner for your project.
The existing reference implementations use a mix of RTOS and hardware platforms.
We have [ChibiOS](https://www.chibios.org/dokuwiki/doku.php) supporting several [ST Microelectronics](https://www.st.com/content/st_com/en.html) development boards, Espressif [ESP32](https://en.wikipedia.org/wiki/ESP32)/S2/C3 and NXP [MIMXRT1060-EVK](https://www.nxp.com/part/MIMXRT1060-EVK#/) running on Free RTOS; Texas Instruments [CC3220 Launchpad](https://www.ti.com/tool/CC3220SF-LAUNCHXL), [CC1352 Launchpad](https://www.ti.com/tool/LAUNCHXL-CC1352R1) running [TI-RTOS](https://www.ti.com/tool/TI-RTOS-MCU) and [Silicon Labs Giant Gecko S1](https://www.silabs.com/mcu/32-bit-microcontrollers/efm32-giant-gecko-gg11) running on [Azure RTOS](https://azure.microsoft.com/en-us/products/rtos/).
Because it’s completely [free and Open Source](https://en.wikipedia.org/wiki/Free_and_open-source_software) you have access to and the ability to modify all parts of the code including the ability to leverage what others have already contributed. If you are willing to, you can help shape the future by contributing back to the project and rapidly growing community.

Here are some of its unique features:

- Can run on resource-constrained devices with as low as 128kB of flash and 64kB of RAM.
- Runs directly on bare metal. [ARM Cortex-M0/4/7](https://en.wikipedia.org/wiki/ARM_Cortex-M), Xtensa LX6/7 ([ESP32](https://en.wikipedia.org/wiki/ESP32)) and RISC-V devices are supported.
- Supports common embedded peripherals and interconnects like GPIO, UART, SPI, I2C, USB, networking.
- Provides multi threading support natively.
- Support for energy-efficient operation such as devices running on batteries.
- Support for Interop code allowing developers to easily write libraries that have both managed (C#) and native code (C/C++).
- No manual memory management because of its simpler mark-and-sweep [garbage collector](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science)).
- Execution constrains to catch device lockups and crashes.

Here are some advantages over other similar systems:

- First class debugger experience right on the target hardware with breakpoints, single step, step into, step out, step over, pause and stop.
- Powerful and free programming environment with [Microsoft Visual Studio IDE](https://www.visualstudio.com/vs/).
- Support for a large range of inexpensive boards from several manufacturers including: Discovery and Nucleo boards from [ST Microelectronics](https://www.st.com/content/st_com/en.html), [Silicon Labs Giant Gecko S1](https://www.silabs.com/mcu/32-bit-microcontrollers/efm32-giant-gecko-gg11), [ESP32](https://en.wikipedia.org/wiki/ESP32) from Espressif, Texas Instruments [CC3220 Launchpad](https://www.ti.com/tool/CC3220SF-LAUNCHXL), [CC1352 Launchpad](https://www.ti.com/tool/LAUNCHXL-CC1352R1), NXP [MIMXRT1060-EVK](https://www.nxp.com/part/MIMXRT1060-EVK#/), [Quail](https://www.mikroe.com/quail) from Mikrobus and [Netduino](https://developer.wildernesslabs.co/Netduino/About/) from Wilderness Labs.
- Easily expandable to other hardware platforms and [RTOSes](https://en.wikipedia.org/wiki/Real-time_operating_system). We have official support for [ChibiOS](https://www.chibios.org/dokuwiki/doku.php), [TI-RTOS](https://www.ti.com/tool/TI-RTOS-MCU), ESP32 FreeRTOS port and [Azure RTOS](https://azure.microsoft.com/en-us/products/rtos/).
- Completely free and [Open Source](https://en.wikipedia.org/wiki/Free_and_open-source_software). From the core components to the utilities used for building, deploying, debugging and IDE components.

In case you wonder: [what is .NET **nanoFramework**?](what-is-nanoframework.md)
