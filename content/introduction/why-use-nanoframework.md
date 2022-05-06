# Why use .NET **nanoFramework**

.NET **nanoFramework** is the perfect enabler for developing software that works on embedded devices. Start with a low cost and readily available development board, then use .NET **nanoFramework** to write, debug and deploy your code.

Whether this is your first foray into programming or are a seasoned developer, if you want a powerful and easy to use tool for developing software that runs on embedded devices, you are in the right place. With its modular architecture, it’s easy to grab the core components (like the CLR, debugger and interpreter) and extendibility to new hardware platforms, .NET **nanoFramework** is the perfect partner for your project. The current reference implementation uses [ChibiOS](http://www.chibios.org/dokuwiki/doku.php) supporting several [ST Microelectronics](http://www.st.com/content/st_com/en.html) development boards and also [ESP32](https://en.wikipedia.org/wiki/ESP32).
Because it’s completely free and [Open Source](https://en.wikipedia.org/wiki/Free_and_open-source_software) you have access to and the ability to modify all parts of the code including the ability to leverage what others have already contributed. If you are willing to, you can help shape the future by contributing back to the project and rapidly growing community.

Here are some of its unique features:

- Can run on resource-constrained devices with as low as 256kB of flash and 64kB of RAM.
- Runs directly on bare metal. Currently there is support for [ARM Cortex-M](https://en.wikipedia.org/wiki/ARM_Cortex-M) and [Xtensa LX6 and LX7](https://en.wikipedia.org/wiki/ESP32) cores.
- Supports common embedded peripherals and interconnects like GPIO, UART, SPI, I2C, USB, networking.
- Provides multithreading support natively.
- Support for energy-efficient operation such as devices running on batteries.
- Support for Interop code allowing developers to easily write libraries that have both managed (C#) and native code (C/C++).
- No manual memory management because of its simpler mark-and-sweep [garbage collector](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science)).
- Execution constrains to catch device lockups and crashes.

Here are some advantages over other similar systems:

- First class debugger experience right on the target hardware with breakpoints, single step, step into, step out, step over, pause and stop.
- Powerful and free programming environment with [Microsoft Visual Studio IDE](https://www.visualstudio.com/vs/).
- Support for a large range of inexpensive boards from several manufacturers including: Discovery and Nucleo boards from [ST Microelectronics](http://www.st.com/content/st_com/en.html), [ESP32 and S2](https://en.wikipedia.org/wiki/ESP32) series, [CC1352R1-LAUNCHXL](https://www.ti.com/tool/LAUNCHXL-CC1352R1) from Texas Instruments, [i.MXRT1060](https://www.nxp.com/design/development-boards/i.mx-evaluation-and-development-boards/mimxrt1060-evk-i.mx-rt1060-evaluation-kit:MIMXRT1060-EVK) from NXP and many others.
- Easily expandable to other hardware platforms and [RTOSes](https://en.wikipedia.org/wiki/Real-time_operating_system). Currently is targeting [ChibiOS](http://www.chibios.org/dokuwiki/doku.php), FreeRTOS, TI-RTOS and ESP32 FreeRTOS port.
- Completely free and [Open Source](https://en.wikipedia.org/wiki/Free_and_open-source_software). From the core components to the utilities used for building, deploying, debugging and IDE components.

In case you wonder: [what is .NET **nanoFramework**?](what-is-nanoframework.md)
