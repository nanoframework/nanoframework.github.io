# Building .NET **nanoFramework** firmware

.NET **nanoFramework** build system is based in CMake. Please read the instructions specific to each target series.

- [STM32](build-stm32.md)
- [ESP32](build-esp32.md)
- [NXP](build-nxp.md)
- [Using Dev Container](using-dev-container.md)

⚠️ NOTE about the need to build .NET **nanoFramework** firmware ⚠️

You only need to build it if you plan to debug the native code, add new targets or add new features at native level.
If your goal is to code in C# you just have to flash your MCU with the appropriate firmware image.
There are available ready to flash firmware images for several targets, please check the [Home](https://github.com/nanoframework/Home#firmware-for-reference-boards) repository.

## About this document

This document describes how to build the required images for .NET **nanoFramework** firmware to be flashed in a SoC or MCU.
The build is based on CMake tool to ease the development in all major platforms.

## Using Dev Container

If you want a simple, efficient way, we can recommend you to use [Dev Container](using-dev-container.md) to build your image. This has few requirements as well like Docker Desktop and Remote Container extension in VS Code but it is already all setup and ready to run!

If you prefer to install all the tools needed on your Windows machine, you should continue this tutorial.

## Prerequisites

You'll need:

- [GNU ARM Embedded Toolchain](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads)
- [CMake](https://cmake.org/) (Minimum required version is 3.7)
- A build system for CMake to generate the build files to.
  - If you have Visual Studio (full version) you can use the included NMake.
  - A nice alternative is [Ninja](https://github.com/ninja-build/ninja). This is lightweight build system, designed for speed and it works on Windows and Linux machines. See [here](cmake/ninja-build.md) how to setup Ninja to build .NET **nanoFramework**.

If you are using VS Code as your development platform we suggest that you use the CMake Tools extension. This will allow you to run the builds without leaving VS Code.

- [Visual Studio Code](http://code.visualstudio.com/)
- [CMake Extension](https://marketplace.visualstudio.com/items?itemName=twxs.cmake)
- [CMake Tools Extension](https://marketplace.visualstudio.com/items?itemName=vector-of-bool.cmake-tools)

In case you specify an RTOS and you want its source to be downloaded from the official repository, you'll need:

- For ChibiOS a SVN client. [Tortoise SVN](https://tortoisesvn.net/downloads) seems to be a popular choice for Windows machines.
- For all the other repositories a Git client. [Fork](https://git-fork.com/) it's a great visual git client packed with a lot of features or [GitHub Desktop](https://desktop.github.com/) seems to be a popular choice for Windows machines.

## Preparation

It's ***highly*** recommended that run the build outside the source tree. This prevents you from cluttering the source tree with CMake artifacts, temporary files etc.
In fact this is enforced and checked by the CMake script.

In case you need to clean up or start a fresh build all you have to do is simply delete the contents of the build directory.

As a suggestion we recommend that you create a directory named *build* in the repository root and run CMake from there.

## Build a .NET **nanoFramework** firmware image

The build script accepts the a number of parameters (some of them are mandatory). Please check the details about each parameter [here](cmake-tools-cmake-variants.md#content-explained).

> Note 1: The RTOSes currently supported (except for ESP32 target) are ChibiOS and FreeRTOS. If no source path is specified the source files will be downloaded from nanoFramework  GitHub fork._
> Note 2: the very first build will take more or less time depending on the download speed of the Internet connection of the machine were the build is running. This is because the source code of the RTOS of your choice will be downloaded from its repository. On the subsequent builds this won't happen._

You can specify any generator that is supported in the platform where you are building.
For more information on this check CMake documentation [here](https://cmake.org/cmake/help/v3.7/manual/cmake-generators.7.html?highlight=generator).

## Building from the command prompt

If you are building from the command prompt, just go to your *build* directory and run CMake from there with the appropriate parameters.
The following is a working example:

```dotnetcli
cmake \
-DTOOLCHAIN_PREFIX="E:/GNU_Tools_ARM_Embedded/5_4_2016q3" \
-DCMAKE_TOOLCHAIN_FILE=CMake/toolchain.arm-none-eabi.cmake \
-DCHIBIOS_BOARD=ST_NUCLEO_F091RC \
-DTARGET_SERIES=STM32F0xx \
-DNF_FEATURE_DEBUGGER=TRUE \
-DAPI_Windows.Devices.Gpio=ON \
-DNF_FEATURE_RTC=ON \
-G "NMake Makefiles" ../
```

This will call CMake (on your *build* directory that is assumed to be under the repository root) specifying the location of the toolchain install, that the target board is named ST_NUCLEO_F091RC, that STM32F0xx is the series name that it belongs to, debugger feature is to be included, Windows.Devices.Gpio API is to be included and that the build files suitable for NMake are to be generated.

Another example:

```text
cmake \
-DTOOLCHAIN_PREFIX="E:/GNU_Tools_ARM_Embedded/5_4_2016q3" \
-DCMAKE_TOOLCHAIN_FILE=CMake/toolchain.arm-none-eabi.cmake \
-DCHIBIOS_SOURCE=E:/GitHub/ChibiOS \
-DCHIBIOS_BOARD=ST_NUCLEO144_F746ZG \
-DTARGET_SERIES=STM32F7xx \
-DNF_FEATURE_DEBUGGER=TRUE \
-DAPI_System.Device.Gpio=ON \
-DNF_FEATURE_RTC=ON \
-G "NMake Makefiles" ../
```

This will call CMake (on your *build* directory that is assumed to be under the repository root) specifying the location of the toolchain install, specifying that ChibiOS sources to be used are located in the designated path (mind the forward slash and no ending slash),  that the target board is named ST_NUCLEO144_F746ZG, that STM32F7xx is the series name that it belongs to, debugger feature is to be included, System.Device.Gpio API is to be included, RTC is used and that the build files suitable for NMake are to be generated.

After successful completion you'll have the build files ready to be used in the target build tool.

## Building from VS Code (using CMake Tools extension)

We've added the required files and configurations to help you launch your build from VS Code.
Follows a brief explanation on the files you might want to tweak.

- settings.json (inside .vscode folder) here you can change the generator that CMake uses to generate the build. The default is ```"cmake.generator": "NMake Makefiles"```. The recommendation is to use Ninja as the build tool because it's way faster than NMake.
  You'll also need to set the use of CMake Server to true, like this: ```"cmake.useCMakeServer" : true```.
- launch.json (inside .vscode folder) here you can set up your launch configurations, such as gdb path or OpenOCD configuration. We've made available Gists with launch.json for several of the reference targets. Grab yours from [here](https://gist.github.com/nfbot). :warning: Remember to update paths and other preferences according to your setup and machine configuration. :wink:
- cmake-variants.json (at the repository root) here you can add several build flavors. You can even add variants to each one. Check the documentation extension [here](https://vector-of-bool.github.io/docs/vscode-cmake-tools/variants.html#). We've made available Gists with cmake-variants.json for each of the reference targets. Grab yours from [here](https://gist.github.com/nfbot). :warning: Remember to update paths and other preferences according to your setup and machine configuration. :wink:

To launch the build in VS Code check the status bar at the bottom. Select the build flavour and then click the build button (or hit <kbd>F7</kbd>).

## .NET **nanoFramework** firmware build deliverables

After a successful build you can find the .NET **nanoFramework** image files in the *build* directory. Those are:

- nanoBooter image (not available for ESP32 builds):

  - nanoBooter.bin (raw binary format)
  - nanoBooter.hex (Intel hex format)
  - nanoBooter.s19 (Motorola S-record format, equivalent to srec)
  - nanoBooter.lst (source code listing intermixed with disassembly)
  - nanoBooter.map (image map)

- nanoCLR image:

  - nanoCLR.bin (raw binary format)
  - nanoCLR.hex (Intel hex format)
  - nanoCLR.s19 (Motorola S-record format, equivalent to srec)
  - nanoCLR.lst (source code listing intermixed with disassembly)
  - nanoCLR.map (image map)

## BUILD_VERSION matching

When working with self built nanoCLR you may get the following message while deploying a new app:

```text
Found assemblies mismatches when checking for deployment pre-check.
```

This is because the BUILD_VERSION value of your custom built nanoCLR doesn't match the one nanoframework.CoreLibrary expects.
BUILD_VERSION can be set cmake-variants.json. The value defaults to `"0.9.99.999"`.
Change that to the one you need at the moment, like `"1.6.1.28"`.

Don't forget to:

- make this change under appropriate target block, as described [here](cmake-tools-cmake-variants.md)
- make sure you understood that VSCode have to be reloaded to these json changes have effect.
- make sure you understood that the build folder have to be removed to these changes have effect.
- re-select the CMake target (VSCode bottom line) to reconfigure the build.
