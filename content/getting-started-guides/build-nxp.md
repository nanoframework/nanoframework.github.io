# How to Build, Flash and Debug the NXP nanoBooter and nanoCLR on Windows using Visual Studio Code

## Table of contents

- [How to Build, Flash and Debug the NXP nanoBooter and nanoCLR on Windows using Visual Studio Code](#how-to-build-flash-and-debug-the-nxp-nanobooter-and-nanoclr-on-windows-using-visual-studio-code)
  - [Table of contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Setting up the build environment for NXP](#setting-up-the-build-environment-for-nxp)
  - [Set up MCUXpresso IDE](#set-up-mcuxpresso-ide)
  - [nanoFramework GitHub repo](#nanoframework-github-repo)
  - [Set up Visual Studio Code](#set-up-visual-studio-code)
  - [Build nanoBooter and nanoCLR](#build-nanobooter-and-nanoclr)
  - [Flash the NXP target](#flash-the-nxp-target)
  - [Debugging with Cortex Debug with J-Link (Optional)](#debugging-with-cortex-debug-with-j-link-optional)
  - [Next Steps](#next-steps)

**About this document**

This document describes how to build the required images for **nanoFramework** for STM32 targets.
The build is based on CMake tool to ease the development in all major platforms.

## Prerequisites

You'll need:

- [Visual Studio Code](http://code.visualstudio.com/)
- Visual Studio Code Extensions
  . [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) - C/C++ IntelliSense, debugging, and code browsing (by Microsoft)
  . [CMake](https://marketplace.visualstudio.com/items?itemName=twxs.cmake) - language support for Visual Studio Code (by twxs)
  . [CMake Tools](https://marketplace.visualstudio.com/items?itemName=vector-of-bool.cmake-tools) - Extended CMake support in Visual Studio Code (by vector-of-bool)
  . [Cortex Debug](https://marcelball.ca/projects/cortex-debug/) - Debug tool made explicity for ARM Cortex-M cores (needed for J-Link), if you're using on board programmer you don't need it.
- [CMake](https://cmake.org/download/) (Minimum required version is 3.11).
- A build system for CMake to generate the build files to.
  . If you have Visual Studio (full version) you can use the included NMake.
  . [Ninja](https://github.com/ninja-build/ninja/releases). This is lightweight build system, designed for speed and it works on Windows and Linux machines. See [here](cmake/ninja-build.md) how to setup Ninja to build **nanoFramework**. This guide will use Ninja.
- [GNU ARM Embedded Toolchain](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads)

## Setting up the build environment for NXP

To simplify, this guide we will put all our tools and source in easily accessible folders and not at the default install paths (you do not have to do the same):

1. Create a directory structure such as the following:

   - `C:\nanoFramework_Tools`
   - `C:\nanoFramework`

2. [Download](http://code.visualstudio.com/) and install Visual Studio Code.

3. [Download](https://cmake.org/download/) and install CMake to `C:\nanoFramework_Tools\CMake`.

4. [Download](https://github.com/ninja-build/ninja/releases) Ninja and place the executable in `C:\nanoFramework_Tools\Ninja`.

5. [Download](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads) and install the GNU ARM Embedded Toolchain to `C:\nanoFramework_Tools\GNU_ARM_Toolchain`.

6. Finally, clone `nf-interpreter` into `C:\nanoFramework\nf-interpreter`. See next section for more info.

## Set up MCUXpresso IDE
For programming eval board using on board LPC-Link programmer you will need to set up MCUXpresso IDE which provides us with redlink software. Redlink copies flash image to core RAM and from there it's flashed into external HyperFlash or QSPI flash.

1. Register and download MCUXpresso IDE form nxp [website](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=2ahUKEwiPwZiTlMHmAhU5AxAIHQkrDNIQFjAAegQIBhAB&url=https%3A%2F%2Fwww.nxp.com%2Fdesign%2Fsoftware%2Fdevelopment-software%2Fmcuxpresso-software-and-tools%2Fmcuxpresso-integrated-development-environment-ide%3AMCUXpresso-IDE&usg=AOvVaw0Oh8kETGeCSOnWTlKyGj_I).
2. Install MCUXpresso IDE.
3. Remeber to set proper paths while setting up `launch.json` file in next steps.

## **nanoFramework** GitHub repo

If you intend to change the nanoBooter or nanoCLR for the NXP target and create Pull Requests then you will need to fork the [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) to your own GitHub repo and clone the forked GitHub repo to your Windows system using an Git client such as the [GitHub Desktop application](https://desktop.github.com/).

See the [Contributing to nanoFramework](https://github.com/nanoframework/Home/blob/master/CONTRIBUTING.md) guide for specific instructions when contributing.

If you don't intend to make changes to the nanoBooter and nanoCLR, you can clone [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) directly from here.

## Set up Visual Studio Code

1. Install the extensions:

    - [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
    - [CMake](https://marketplace.visualstudio.com/items?itemName=twxs.cmake)
    - [CMake Tools](https://marketplace.visualstudio.com/items?itemName=vector-of-bool.cmake-tools)

1. Set up the `CMake-variants.json` in root directory of your local nanoFramework/nf-interpreter clone.
  
    There is a template file called `cmake-variants.TEMPLATE.json` that can be renamed and configured accordingly.

    More info available on the [Tweaking cmake-variants.TEMPLATE.json](https://github.com/nanoframework/Home/blob/master/docs/building/cmake-tools-cmake-variants.md) documentation page.

    For any of the [Reference target boards](http://docs.nanoframework.net/content/reference-targets-intro.html) you can find pre-populated template files [here](https://github.com/nanoframework/Home/blob/c2eb47665ed426a000e18858cbdf5d71cb836421/docs/building/cmake-tools-cmake-variants.md#templates).
\
    Here is an example `CMake-variants.json` for the MIMXRT1060 evalboard:

```json
{
  "buildType": {
    "default": "MinSizeRel",
    "choices": {
      "debug": {
        "short": "Debug",
        "long": "Emit debug information without performing optimizations",
        "buildType": "Debug"
      },
      "release": {
        "short": "Release",
        "long": "Enable optimizations, omit debug info",
        "buildType": "Release"
      },
      "minsize": {
        "short": "MinSizeRel",
        "long": "Optimize for smallest binary size",
        "buildType": "MinSizeRel"
      },
      "reldeb": {
        "short": "RelWithDebInfo",
        "long": "Perform optimizations AND include debugging information",
        "buildType": "RelWithDebInfo"
      }
    }
  },
  "linkage": {
    "default": "",
    "choices": {
      "MIMXRT1060_EVK": {
        "short": "MIMXRT1060_EVK",
        "settings": {
          "BUILD_VERSION": "0.9.99.999",
          "CMAKE_TOOLCHAIN_FILE" : "CMake/toolchain.arm-none-eabi.cmake",
          "TOOLCHAIN_PREFIX": "C:/nanoFramework_Tools/GNU_ARM_Toolchain/8 2019-q3-update",		
          "TOOL_SRECORD_PREFIX" : "c:/nanoFramework_Tools/srecord/",
          "TARGET_SERIES": "IMXRT10xx",
          "SUPPORT_ANY_BASE_CONVERSION": "ON",
          "RTOS": "FREERTOS",
          "FREERTOS_BOARD": "NXP_MIMXRT1060_EVK",
          "FREERTOS_VERSION": "v1.4.8",
          "CMSIS_VERSION": "5.5.1",
          "FATFS_VERSION": "R0.13c",
          "LWIP_VERSION": "STABLE-2_0_3_RELEASE",
          "NF_BUILD_RTM": "OFF",
          "NF_FEATURE_DEBUGGER": "ON",
          "NF_FEATURE_HAS_SDCARD": "ON",
          "NF_FEATURE_RTC": "ON",
          "NF_FEATURE_HAS_CONFIG_BLOCK": "ON",
          "NF_SECURITY_OPENSSL": "OFF",
          "API_Windows.Devices.Gpio": "ON",
          "API_Windows.Devices.SerialCommunication": "ON",
          "API_nanoFramework.ResourceManager": "ON",
          "API_nanoFramework.System.Collections": "ON",
          "API_System.Net": "ON",
          "API_System.Math": "ON",
          "API_Windows.Storage": "ON"
        }
      }
    }
  }
}
```

3. In the`.vscode` create a file named `settings.json` and paste the following (mind to update the path to your setup):

```json
{
    "cmake.preferredGenerators": [
        "Ninja"
    ],
    "cmake.generator": "Ninja",
    "cmake.useCMakeServer" : true,
    "cmake.autoRestartBuild" : true,
    "cmake.configureSettings": {
        "CMAKE_MAKE_PROGRAM":"C:/nanoFramework_Tools/ninja/ninja.exe"
    },
    "cmake.cmakePath": "C:/nanoFramework_Tools/CMake/bin/cmake.exe",

    "cortex-debug.armToolchainPath": "c:/nanoFramework_Tools/GNU_ARM_Toolchain/8 2019-q3-update/bin",
    "cortex-debug.JLinkGDBServerPath": "c:/Program Files (x86)/SEGGER/JLink/JLinkGDBServerCL.exe"
}
```

> Note: if the path to CMake executable is on the PATH system variable the last setting (`cmake.cmakePath`) is not required.

> Note: if you want to use onboard programmer you can remove two last lines.

4. In the `.vscode` create a file named `launch.json` and paste the following (mind to set proper paths):
   
```json
   {
    "version": "0.2.0",
    "configurations": [   
        {
            "name": "MIMXRT1060 Launch nanoBooter",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/Build/nanoBooter.elf",
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": true,
            "MIMode": "gdb",
            "miDebuggerPath": "c:/nanoFramework_Tools/GNU_ARM_Toolchain/8 2019-q3-update/bin/arm-none-eabi-gdb.exe",
            "setupCommands": [
                 {"description":"","text": "set breakpoint pending on"},
                 {"description":"","text": "-enable-pretty-printing"},
                 {"description":"","text": "set python print-stack none"},
                 {"description":"","text": "set print object on"},
                 {"description":"","text": "set print sevenbit-strings on"},
                 {"description":"","text": "set charset ISO-8859-1"},
                 {"description":"","text": "set auto-solib-add on"},
                 {"description":"","text": "file C:/nanoFramework/nf-interpreter/Build/nanoBooter.elf"},
                 {"description":"","text": "set non-stop on"},
                 {"description":"","text": "set pagination off"},
                 {"description":"","text": "set mi-async"},
                 {"description":"","text": "set remotetimeout 60"},
                 {"description":"","text": "target extended-remote | C:/nxp/MCUXpressoIDE_11.0.0_2516/ide/binaries/crt_emu_cm_redlink.exe -g -mi -2 -pMIMXRT1062xxxxA -vendor=NXP --reset= -cache=disable --flash-dir=C:/nxp/MCUXpressoIDE_11.0.0_2516/ide/binaries/Flash --flash-driver=MIMXRT1060_SFDP_QSPI.cfx --no-packed"},
                 {"description":"","text": "set mem inaccessible-by-default off"},
                 {"description":"","text": "mon ondisconnect cont"},
                 {"description":"","text": "set arm force-mode thumb"},
                 {"description":"","text": "set remote hardware-breakpoint-limit 6"},
                 {"description":"","text": "mon semihost enable"},
                 {"description":"","text": "load"},
                 {"description":"","text": "thbreak main"}
            ]
        },
        {
            "name": "MIMXRT1060 Launch",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/build/nanoCLR.elf",
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": true,
            "MIMode": "gdb",
            "miDebuggerPath": "c:/nanoFramework_Tools/GNU_ARM_Toolchain/8 2019-q3-update/bin/arm-none-eabi-gdb.exe",
            "setupCommands": [
                 {"description":"","text": "set breakpoint pending on"},
                 {"description":"","text": "-enable-pretty-printing"},
                 {"description":"","text": "set python print-stack none"},
                 {"description":"","text": "set print object on"},
                 {"description":"","text": "set print sevenbit-strings on"},
                 {"description":"","text": "set charset ISO-8859-1"},
                 {"description":"","text": "set auto-solib-add on"},
                 {"description":"","text": "file C:/nanoFramework/nf-interpreter/build/nanoCLR.elf"},
                 {"description":"","text": "set non-stop on"},
                 {"description":"","text": "set pagination off"},
                 {"description":"","text": "set mi-async"},
                 {"description":"","text": "set remotetimeout 60"},
                 {"description":"","text": "target extended-remote | C:/nxp/MCUXpressoIDE_11.0.0_2516/ide/binaries/crt_emu_cm_redlink.exe -g -mi -2 -pMIMXRT1062xxxxA -vendor=NXP --reset= -cache=disable --flash-dir=C:/nxp/MCUXpressoIDE_11.0.0_2516/ide/binaries/Flash --flash-driver=MIMXRT1060_SFDP_QSPI.cfx --no-packed"},
                 {"description":"","text": "set mem inaccessible-by-default off"},
                 {"description":"","text": "mon ondisconnect cont"},
                 {"description":"","text": "set arm force-mode thumb"},
                 {"description":"","text": "set remote hardware-breakpoint-limit 6"},
                 {"description":"","text": "mon semihost enable"},
                 {"description":"","text": "load"},
                 {"description":"","text": "thbreak main"},
            ],
            "logging": {
                "engineLogging": true
			}
		}
    ]
   }
   
```

5. Save all files and exit VS Code.

2. Reopen VS Code. It should load the workspace automatically. In the status bar at the bottom left, click on the `No Kit Selected` and select `[Unspecified]`.

3. In the status bar at the bottom left, click on the `CMake:MinSizeRel MIMXRT1060_EVK: Ready` and select `MinSizeRel`. Wait for it to finish Configuring the project (progress bar shown in right bottom corner).

## Build nanoBooter and nanoCLR

1. In the status bar click `Build`.

1. Wait for the build to finish with `Build finished with exit code 0` output message.

1. In the `C:\nanoFramework\nf-interpreter\build` folder will be the required binary files:

- nanoBooter.bin
- nanoBooter.elf
- nanoBooter.hex
- nanoCLR.bin
- nanoCLR.elf
- nanoCLR.hex

## Flash the NXP target

1. Connect the Target board to your PC using an USB cable.
2. Open Visual Studio Code and go to `Debug and Run` (CTRL+SHIFT+D).
3. Run debug (green rectangle or F5 default shortcut), firstly on nanoBooter then nanoCLR.
4. You don't have to reflash nanoBooter everytime you flash nanoCLR.

## Debugging with Cortex Debug with J-Link (Optional)
If you want to view CPU register values in real time and use more advanced debbuging tool. It's possible to use Cortex Debug extension. Please refer to guides avaliable at SEGGERs wiki.


## Next Steps

See [Getting Started](http://docs.nanoframework.net/content/getting-started-guides/getting-started-managed.html) for instructions on creating and running a 'Hello World' managed application on your nanoFramework board.
