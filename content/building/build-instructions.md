# Building .NET **nanoFramework** firmware

.NET **nanoFramework** build system is based in CMake. Please read the instructions specific to each target series.

- [STM32](build-stm32.md)
- [ESP32](build-esp32.md)
- [NXP](build-nxp.md)
- [Using Dev Container](using-dev-container.md)

⚠️ NOTE about the need to build .NET **nanoFramework** firmware ⚠️

You only need to build it if you plan to debug the CLR, interpreter, execution engine, drivers, add new targets or add new features at native level.
If your goal is to code in C# you just have to flash your MCU with the appropriate firmware image using [nanoff](https://github.com/nanoframework/nanoFirmwareFlasher).
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
- [CMake](https://cmake.org/) (Minimum required version is 3.23)
- A build tool for CMake to generate the build files to. We recommend [Ninja](https://github.com/ninja-build/ninja). This is lightweight build system, designed for speed and it works on Windows and Linux machines. See [here](cmake/ninja-build.md) how to setup Ninja to build .NET **nanoFramework**.

If you are using VS Code as your development platform we suggest that you use the CMake Tools extension. This will allow you to run the builds without leaving VS Code.

- [Visual Studio Code](http://code.visualstudio.com/)
- [CMake Extension](https://marketplace.visualstudio.com/items?itemName=twxs.cmake)
- [CMake Tools Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools)

In case you specify an RTOS and you want its source to be downloaded from the official repository, you'll need:

- For ChibiOS a SVN client. [Tortoise SVN](https://tortoisesvn.net/downloads.html) seems to be a popular choice for Windows machines.
- For all the other repositories a Git client. [Fork](https://git-fork.com/) it's a great visual git client packed with a lot of features or [GitHub Desktop](https://desktop.github.com/) seems to be a popular choice for Windows machines.

## Preparation

It's ***highly*** recommended that run the build outside the source tree. This prevents you from cluttering the source tree with CMake artifacts, temporary files etc.
In fact this is enforced and checked by the CMake script.

In case you need to clean up or start a fresh build all you have to do is simply delete the contents of the build directory.

As a suggestion we recommend that you create a directory named *build* in the repository root and run CMake from there.

## Build a .NET **nanoFramework** firmware image

The build script accepts the a number of parameters (some of them are mandatory). Please check the details about each parameter [here](cmake-presets.md).

> Note 1: The RTOSes currently supported (except for ESP32 target) are ChibiOS for STM32 targets, FreeRTOS for NXP and TI-RTOS for TI targets. If no source path is specified the source files will be downloaded from nanoFramework  GitHub fork.
> Note 2: the very first build will take more or less time depending on the download speed of the Internet connection of the machine were the build is running. This is because the source code of the RTOS of your choice will be downloaded from its repository. On the subsequent builds this won't happen.

You can specify any generator that is supported in the platform where you are building.
For more information on this check CMake documentation [here](https://cmake.org/cmake/help/v3.23/manual/cmake-generators.7.html?highlight=generator).

## Building from the command prompt

If you are building from the command prompt, just go to the repository root folder and run CMake from there with the appropriate parameters.
The following is a working example:

```text
cmake --preset ST_NUCLEO_F091RC
cmake --build --preset ST_NUCLEO_F091RC
```

This will call CMake and build the ST_NUCLEO_F091RC target from that configuration preset. It's assumed that you've previously adjusted the tools path in the CMakeUserPresets.json file.

Any of the build options in the cache variables can be overridden from the CLI like in the example below here we're setting the TOOLCHAIN_PREFIX:

```text
cmake --preset ST_NUCLEO144_F746ZG -DTOOLCHAIN_PREFIX="E:/GNU_Tools_ARM_Embedded/10.3-2021.10"
cmake --build --preset ST_NUCLEO144_F746ZG
```

After successful completion you'll have the build files ready to be used in the target build tool.

## Building from VS Code (using CMake Tools extension)

We've added the required files and configurations to help you launch your build from VS Code.
Follows a brief explanation on the files you might want to tweak.

- settings.json (inside .vscode folder) here you can change the generator that CMake uses to generate the build. The default is ```"cmake.generator": "NMake Makefiles"```. The recommendation is to use Ninja as the build tool because it's way faster than NMake.
- launch.json (inside .vscode folder) here you can set up your launch configurations, such as gdb path or OpenOCD configuration. We've made available Gists with launch.json for several of the reference targets. Grab yours from [here](https://gist.github.com/nfbot). :warning: Remember to update paths and other preferences according to your setup and machine configuration. :wink:
- CMakeUserPresets.TEMPLATE.json (at the repository root). You should copy this one over to CMakeUserPresets.json. Besides adjusting the paths to the location where you have the tools installed locally, you can tweak build options, add new build configurations and override the default ones. Check the documentation [here](https://github.com/microsoft/vscode-cmake-tools/blob/main/docs/cmake-presets.md). **!!mind to always use forward slashes in the paths!!**
:warning: Remember to update paths and other preferences according to your setup and machine configuration. :wink:

To launch the build in VS Code check the status bar at the bottom. Select the Configure Preset that you want and click the build button (or hit <kbd>F7</kbd>).

![choose-preset](../../images/building/vs-code-bottom-tolbar-choose-preset.png)

## .NET **nanoFramework** firmware build deliverables

After a successful build you can find the .NET **nanoFramework** image files in the *build* directory. Those are:

- nanoBooter image (not available for ESP32 builds):

  - nanoBooter.bin (raw binary format)
  - nanoBooter.hex (Intel hex format)
  - nanoBooter.lst (source code listing intermixed with disassembly)
  - nanoBooter.map (image map)

- nanoCLR image:

  - nanoCLR.bin (raw binary format)
  - nanoCLR.hex (Intel hex format)
  - nanoCLR.lst (source code listing intermixed with disassembly)
  - nanoCLR.map (image map)

## BUILD_VERSION matching

When working with self built nanoCLR you may get the following message while deploying a new app:

```text
Found assemblies mismatches when checking for deployment pre-check.
```

This is because the BUILD_VERSION value of your custom built nanoCLR doesn't match the one nanoframework.CoreLibrary expects.
`BUILD_VERSION` can be set in the file `CMakeUserPresets.json`. The value defaults to `"0.9.99.999"`.
Change that to the one you need at the moment, like `"1.6.1.28"`.

Don't forget to:

- make this change under appropriate target block, as described [here](cmake-presets.md)
- re-select the CMake target (VSCode bottom line) to reconfigure the build.
- you're better running CMake command: 'delete cache and reconfigure' for this to become effective.
