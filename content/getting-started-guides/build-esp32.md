# How to Build, Flash and Debug the ESP32 nanoCLR on Windows using Visual Code

## Table of contents

- [Prerequisites](#prerequisites)
- [Overview](#overview)
- [Setting up the build environment for ESP32](#setting-up-the-build-environment-for-esp32)
- [Set up Visual Studio Code](#set-up-visual-studio-code)
- [Build nanoCLR](#build-nanoclr)
- [Common Build Issues](#common-build-issues)
- [Flash nanoCLR to ESP32](#flash-nanoclr-into-esp32)
- [Start with a Hello World C# application](#start-with-a-hello-world-c-application)
- [Debug the nanoCLR](#debugging-nanoclr)
- [Notes on JTAG Debugging on ESP32](#notes-on-jtag-debugging-on-esp32)
- [Debug the nanoCLR without special hardware](#debugging-nanoclr-without-special-hardware)

**About this document**

This document describes how to build the required images for **nanoFramework** for ESP32.
The build is based on CMake tool to ease the development in all major platforms.

## Prerequisites

You'll need these installed before your start.

- [Git for Windows](https://git-scm.com/). Helpful for doing `git clone` in a command window.
- [Visual Studio Code](http://code.visualstudio.com/). Additional extensions and setup steps follow below. [Set up Visual Code](#Set-up-Visual-Code)
- [Python 3.6.5](https://www.python.org/ftp/python/3.6.5/python-3.6.5.exe) Required for uploading the nanoCLR to the ESP32.
  - Ensure the Windows default app to open `.py` files is Python.
- [CMake](https://cmake.org/download/) Download the latest stable version and install it (Minimum required version is 3.11).
- A build system for CMake to generate the build files to.
  - If you have Visual Studio (full version) you can use the included NMake.
  - In Visual Studio Code, use Ninja. Ninja can be installed for you or you can do it manually.
- [CP210x USB to UART Bridge](https://www.silabs.com/products/development-tools/software/usb-to-uart-bridge-vcp-drivers) Driver for the USB to UART Bridge integrated into the standard ESP32 DevKitC. If Windows does not install the driver automatically, then you can download and install manually. If your ESP32 uses a different serila driver, install that and ignore this driver. With the ESP32 DevKitC plugged in, use Windows Device Manager to determine the COM port as this is needed to complete the setup.

The following may be installed [manually](#Manual-Install-of-the-build-environment-for-ESP32), or use the Power Shell script `.\install-esp32-tools.ps1` from the `install-scripts` folder withing the [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) project (cloned or downloaded)

- [Ninja](https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-win.zip). This is lightweight build system, designed for speed and it works on Windows and Linux machines. See [here](../building/cmake/ninja-build.md) how to setup Ninja to build **nanoFramework**.
- [OpenOCD](https://github.com/espressif/openocd-esp32/releases/download/v0.10.0-esp32-20180418/openocd-esp32-win32-0.10.0-esp32-20180418.zip) For on chip debugging of the nanoCLR

## Overview

The setup will involve the following steps:
1. Install all the prerequisites from above.
2. Clone or download the [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) repository to a location that is pretty short (long path names will cause issues) 
   ```
   if not exist "c:\nanoFramework" mkdir c:\nanoFramework
   cd /D C:\nanoFramework
   git clone https://github.com/nanoframework/nf-interpreter.git
   ```
3. Run the `install-esp32-tools.ps1 -COMPORT COM[n]` as documented below (highly recommended instead of manual)
   For best results, run in an elevated command prompt, otherwise setting system environnment variables will fail.
4. Review and adjust several JSON files to match your environment (as documented below)
5. Restart Visual Studio Code (due to json changes)
6. Build (and repeat 4.5.6 until it works - should be easy)

The setup is a lot easier than it seems. The setup scripts do almost everything.

## **nanoFramework** GitHub repo

If you intend to change the nanoCLR for ESP32 and create Pull Requests then you will need to fork the [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) to your own GitHub repo and clone the forked GitHub repo to your Windows system using an Git client such as the [GitHub Desktop application](https://desktop.github.com/).

You should use the _develop_ branch for mainstream development or the _develop-network_ branch to work with the networking features which is currently a work in progress.

Make sure to put this folder high enough on your drive, that you won't trigger long filename issues. CMAKE does not support filenames in excess of 250 characters. The recommended location is `C:\nanoFramework`.

A guide to making contributions is provided [here](https://github.com/nanoframework/Home/blob/master/CONTRIBUTING.md)

## Setting up the build environment for ESP32

After cloning the repo, you need to setup the build environment. You can use the power shell script or follow the step-by-step instructions.

## Automated Install of the build environment for ESP32

__The following power shell script is not signed. Run Power Shell as an Administrator and run `set-executionpolicy remotesigned` to enable execution of the non-signed script.__

On Windows, one may use the `.\install-esp32-tools.ps1` Power Shell script located in the repository `install-scripts` folder to download the ESP32 IDF Source, toolchain, prebuilt libraries, OpenOCD (for JTAG debugging) and Ninja Zips. You may need to use __Run as Administrator__ for power shell to permit installing modules to unzip the downloaded archives. The script will download the zips into the repository `zips` folder and extract them into sub-folders of the main ESP32 tool folder:

- `C:\Esp32_Tools`

Open Power Shell in the `install-scripts` folder of the repository and run the script specifying the COM port the ESP32 flash programming utility will use (The COM port is easily changed later. If it is not specified, manually edit tasks.json and change instances of `<COMPORT>` to the required port before flashing the ESP32 nanoCLR firmware.)

Example Power Shell command line:

```ps
.\install-esp32-tools.ps1 -COMPORT COM19
```

You can force the environment variables to be updated by adding -Force to the command line.

The script will create the following sub-folders (see manual install below and appveyor.yml)

- `C:\Esp32_Tools`
- `C:\Esp32_Tools\esp-idf-v3.3`
- `C:\Esp32_Tools\libs-v3.3`
- `C:\Esp32_Tools\ninja`  
- `C:\Esp32_Tools\openocd-esp32`  

The following Environment Variables will be created for the current Windows User.

- `ESP32_TOOLS_PATH = C:\ESP32_TOOLS`
- `ESP32_TOOLCHAIN_PATH = C:\ESP32_TOOLS\xtensa-esp32-elf`
- `ESP32_LIBS_PATH = C:\ESP32_TOOLS\libs-v3.3`
- `IDF_PATH = C:\ESP32_TOOLS\esp-idf-v3.3`
- `NINJA_PATH = C:\ESP32_TOOLS\ninja`

The following ESP32 settings files will be created and the place-holder values set to the respective default install paths.

- `.\cmake-variants.json` as a copy of `.\cmake-variants.TEMPLATE-ESP32.json`
- `.\.vscode\cmake-kits.json` as a copy of `.\.vscode\cmake-kits.TEMPLATE-ESP32.json`
- `.\.vscode\tasks.json` as a copy of `.\.vscode\tasks.TEMPLATE-ESP32.json` with install paths and COM port set
- `.\.vscode\launch.json` as a copy of `.\.vscode\launch.TEMPLATE-ESP32.json` with install paths set
- `.\.vscode\settings.json` as a copy of `.\.vscode\settings.TEMPLATE-ESP32.json`

Edit all these files and audit their content. You may need to replace some paths, for example: `<absolute-path-to-the-toolchain-folder-mind-the-forward-slashes>` with `C:/ESP32_TOOLS/esp-idf-v3.3`

Please note all these JSON files require all paths separators to be forward slashes `/`. Example: `C:\ESP32_TOOLS\esp-idf-v3.3` will need to be typed like this: `C:/ESP32_TOOLS/esp-idf-v3.3` (forward slash manner)

## Manual Install of the build environment for ESP32

These steps are not required if you used the Automated Install script.

To save time on building the nanoCLR and to avoid having to create a CMakeLists.txt project for the ESP32 IDF files, the ESP32 IDF libraries are prebuilt using the Esp32 Msys32 environment then used for linking in the CMake build of nanoCLR.
This has already been done and the libraries can be just be downloaded.

1. Create a directory such as the following:

   - `C:\Esp32_Tools`
   - `C:\Esp32_Tools\libs-v3.3`

2. Download the pre-built libs zip from [here](https://bintray.com/nfbot/internal-build-tools/download_file?file_path=IDF_libs-v3.3.zip) and extract it into `C:\Esp32_Tools\libs-v3.3`.

3. Download the v3.3 IDF source zip file from [here](https://github.com/espressif/esp-idf/releases/download/v3.3/esp-idf-v3.3.zip) and extract it into `C:\Esp32_Tools` so you get `C:\ESP32_Tools\esp-idf-v3.3\components` etc.

4. Download the Esp32 toolchain from [here](https://dl.espressif.com/dl/xtensa-esp32-elf-win32-1.22.0-80-g6c4433a-5.2.0.zip) and extract it into `C:\Esp32_Tools` so you get `C:\Esp32_Tools\xtensa-esp32-elf`.

5. For on chip debugging of the nanoCLR, download OpenOCD from [here](https://github.com/espressif/openocd-esp32/releases/download/v0.10.0-esp32-20180724/openocd-esp32-win32-0.10.0-esp32-20180724.zip) and extract OpenOCD into `C:\Esp32_Tools` so you get `C:\Esp32_Tools\openocd-esp32`.

6. Download the light weight build system Ninja for CMake to generate the build files from [here](https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-win.zip). This is lightweight build system, designed for speed and it works on Windows and Linux machines. See [here](../building/cmake/ninja-build.md) how to setup Ninja to build **nanoFramework**.
    > If you have Visual Studio (full version) you can use the included NMake.
  
7. Define the environment variables to match the install locations. Default locations are:
   - `ESP32_TOOLS_PATH = C:\ESP32_TOOLS`
   - `ESP32_TOOLCHAIN_PATH = C:\ESP32_TOOLS\xtensa-esp32-elf`
   - `ESP32_LIBS_PATH = C:\ESP32_TOOLS\libs-v3.3`
   - `IDF_PATH = C:\ESP32_TOOLS\esp-idf-v3.3`
   - `NINJA_PATH = C:\ESP32_TOOLS\ninja`

8. Add Ninja to the PATH (i.e. `C:\ESP32_TOOLS\ninja`)

## Set up CMake

Download the latest stable version from [here](https://cmake.org/download/) and install it.

## Set up Ninja

Extract the exe into `C:\Esp32_Tools\ninja` and add the `C:\Esp32_Tools\ninja` directory to your path variable.

Note that `.\install-esp32-tools.ps1` will do this for you.

## Set up Python

Install [Python 3.6.5](https://www.python.org/ftp/python/3.6.5/python-3.6.5.exe) and then install the serial driver for python from the command line:

```cmd
python -m pip install pyserial
```

Note that `.\install-esp32-tools.ps1` will install `pyserial` for you if you installed Python prior to running the script. (It is Ok to run `python -m pip install pyserial` multiple times.)

## Set up Visual Studio Code

1. Install the extensions:

    - [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) - C/C++ IntelliSense, debugging, and code browsing (by Microsoft)
    - [CMake](https://marketplace.visualstudio.com/items?itemName=twxs.cmake) - language support for Visual Studio Code (by twxs)
    - [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) - Extended CMake support in Visual Studio Code (by Microsoft)

    Next: the following JSON files should be already setup if you used the install script.

2. Set up the `CMake-variants.json` in root directory of your local nanoFramework/nf-interpreter clone.

    See `cmake-variants.TEMPLATE.json` for the generalised template. Be aware of the forward slashes in the paths.
    The TOOLCHAIN_PREFIX should be set to the directory where the xtensa-esp32-elf is the subdirectory.

    There is a template file called `cmake-variants.TEMPLATE-ESP32.json` that can be copied to `CMake-variants.json` and used if you followed the paths in this guide. If different install paths were used, then edit the file accordingly.

```json
{
    "buildType": {
      "default": "debug",
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
  
        "Esp32_nanoCLR": { 
        "short": "NanoCLR",
          "settings": {
            "BUILD_VERSION" : "0.9.99.999",
            "CMAKE_TOOLCHAIN_FILE" : "CMake/toolchain.xtensa-esp32-elf.cmake",
            "TOOLCHAIN_PREFIX" : "<absolute-path-to-the-toolchain-prefix-folder-mind-the-forward-slashes>",
            "ESP32_IDF_PATH" : "<absolute-path-to-the-IDF-folder-mind-the-forward-slashes>",
            "ESP32_LIBS_PATH" : "<absolute-path-to-the-bootloader-folder-mind-the-forward-slashes>",
            "TARGET_SERIES" : "ESP32",
          "USE_FPU" : "TRUE",
          "RTOS" : "FREERTOS",
          "SWO_OUTPUT" : "OFF",
          "NF_BUILD_RTM" : "OFF",
          "NF_WP_TRACE_ERRORS" : "OFF",
          "NF_WP_TRACE_HEADERS" : "OFF",
          "NF_WP_TRACE_STATE" : "OFF",
          "NF_WP_TRACE_NODATA" : "OFF",
          "NF_WP_TRACE_ALL" : "OFF",
          "NF_WP_IMPLEMENTS_CRC32" : "OFF",
          "NF_FEATURE_DEBUGGER" : "ON",
          "NF_FEATURE_RTC" : "ON",
          "NF_FEATURE_USE_APPDOMAINS" : "OFF",
          "NF_FEATURE_USE_FILESYSTEM" : "OFF",
          "NF_SECURITY_MBEDTLS" : "ON",
          "API_System.Net" : "ON",
          "API_System.Devices.Dac" : "ON",
          "API_Windows.Networking.Sockets" : "OFF",
          "API_Windows.Devices.Wifi": "ON",
          "API_Windows.Devices.Adc" : "ON",
          "API_Windows.Devices.Gpio" : "ON",
          "API_Windows.Devices.I2c" : "ON",
          "API_Windows.Devices.Pwm" : "ON",
          "API_Windows.Devices.SerialCommunication" : "ON",
          "API_Windows.Devices.Spi" : "ON",
          "API_Hardware.Esp32" : "ON"
        }
      }
    }
  }
}
```

3. Create a `./.vscode/cmake-kits.json` from `/.vscode/cmake-kits.TEMPLATE-ESP32.json`.

The default template file is ok, and may be copied to `./.vscode/cmake-kits.json`

```json
[
  {
    "name": "ESP32 Tools",
    "toolchainFile": "CMake/toolchain.FreeRtos.ESP32.GCC.cmake"
  }
]
```

4. Create a `./.vscode/tasks.json` from `/.vscode/tasks.TEMPLATE-ESP32.json`.

    For flashing the nanoCLR into the ESP32 or to erase the flash of the ESP32 you will need a `tasks.json` file. You can manually copy the template (`tasks.TEMPLATE-ESP32.json`) and then adjust the COM port and the varios paths with place holders (**!!mind the forward slashes!!**) to your needs. The Power Shell script `.\install-esp32-tools.ps1` will adjust the file for you if you used it.  Use the parameter '-C COM6' to select COM6 for flashing the ESP32 DevKitC.

```json
{
    "version": "2.0.0",
        "tasks": [
        {
            "taskName": "Flash nanoCLR <COMPORT>",
            "type": "shell",
            "command": "python <absolute-path-to-the-IDF-folder-mind-the-forward-slashes>/components/esptool_py/esptool/esptool.py --chip esp32 --port \"<COMPORT>\" --baud 460800 --before \"default_reset\" --after \"hard_reset\" write_flash -z --flash_mode \"dio\" --flash_freq \"40m\" --flash_size detect 0x1000 <absolute-path-to-the-bootloader-folder-mind-the-forward-slashes>/bootloader.bin 0x10000 <path-to-nanoFramework-build-directory-mind-the-forward-slashes>/nanoCLR.bin 0x8000 <path-to-nanoFramework-build-directory-mind-the-forward-slashes>/partitions_4mb.bin",
            "presentation": {
                "reveal": "always",
                "panel": "shared"
            },
            "problemMatcher": []
        },
        {
            "taskName": "Erase flash <COMPORT>",
            "type": "shell",
            "command": "python <absolute-path-to-the-IDF-folder-mind-the-forward-slashes>/components/esptool_py/esptool/esptool.py --chip esp32 --port \"<COMPORT>\" --baud 460800 --before \"default_reset\" --after \"hard_reset\" erase_flash",
            "presentation": {
                "reveal": "always",
                "panel": "shared"
            },
            "problemMatcher": []
        }
    ]
}
```

5. In the`.vscode` create a file named `settings.json` and paste the following (mind to update the path to your setup):

```json
{
    "cmake.preferredGenerators": [
        "Ninja"
    ],
    "cmake.generator": "",
    "cmake.useCMakeServer" : true,
    "cmake.autoRestartBuild" : true,
    "cmake.configureSettings": {
        "CMAKE_MAKE_PROGRAM":"C:/ESP32_TOOLS/ninja/ninja.exe"
    },
    "cmake.configureOnOpen": false,
    "C_Cpp.default.configurationProvider": "vector-of-bool.cmake-tools"
}
```

> Note: if the path to CMake executable is on the PATH system variable the last setting (`cmake.cmakePath`) is not required.

6. Save all files and exit VS Code.

## Build nanoCLR

1. Launch Visual Studio and from the __File__ menu, select __Open Folder__ and browse to the repo folder. VSCode will prompt asking "Would you like to configure this project?". Ignore the prompt as you need to select the build variant first.

   To enter a command into Visual Studio Code use the key combination Ctrl+Shift+P.

1. Click on `CMake` in the Status bar or enter the command

    ```cmd
    CMake: Set build variant
    ```

    and set it to the `Debug + NanoCLR` build type.

    If it also asks for a kit select `ESP32 Tools`

    Wait for CMake to process the files and build the CMake cache. This can take a while the first time. 

1. Press F7, or click on `Build` in the Status bar or enter the command

    ```json
    CMake: Build
    ```

1. If you get no error you will have in the build directory the files `nanoCLR.bin` and `partitions_4mb.bin`.

1. The third file that gets flashed into the ESP32 is the `bootloader.bin` which will be located here `C:/ESP32_Tools/libs-v3.3/bootloader.bin` if the automated install script is used.

    Note: If there are errors during the build process it is possible to end up with a partial build in the `build` folder, and the `CMake/Ninja` build process declaring a successful build despite the `.bin` targets not being created, and a `CMake clean` not helping.
    In this case deleting the contents of the `build` folder should allow the build to complete once you resolve the issues that cause the original failure.

## Common Build Issues

The above may have some errors if:
- CMAKE: may not be installed properly, or not in the PATH and cannot be found.
- NINJA is not recognized: check settings.json, check your PATH environment variable and restart Visual Studio Code. 
- COMPILATION object file not found: check that your paths don't exceed 140 chars. Put the solution folder high enough on your C drive.
- Make sure to 'Build all' first time.
- Make sure to open the CMAKE extension and trigger a 'Clean Reconfigure' from itse '...' menu. Especially if you moved the folder location.

## Flash nanoCLR into ESP32

1. Connect your development board to the computer port that you've setup in `tasks.json`.

1. Bring your board into download mode by holding down the GPIO0 pin to GND or holding down the respective button during power up.

1. In Visual Studio Code enter the command

    ```cmd
    Tasks: Run task
    ```

    and if you flash the board for the first time

    ```cmd
    Erase flash
    ```

    and then

    ```cmd
    Flash nanoCLR
    ```

## Start with a 'Hello World' C# application

Watch the video tutorial [here](https://youtu.be/iZdN2GmefXI) and follow the step that should be done in Visual Studio 2017 Community Edition. Skip the steps that describing uploading the nanoCLR into the STM32 Nucleo board.

## Debugging nanoCLR

If you want to debug the nanoCLR on the ESP32 chip you can use the Olimex ARM-USB-OCD-H JTAG debugging adapter. The following setup is specific for the Olimex ARM-USB-OCD-H but you can use other configuration files to get it working with other JTAG adapters.

Create a `./.vscode/launch.json` from `/.vscode/launch.TEMPLATE-ESP32.json`.

Edit the file and adjust the absolute path `<absolute-path-to-the-build-folder-mind-the-forward-slashes>` to the build folder (**!!mind the forward slashes!!**) to your needs. The Power Shell script `.\install-esp32-tools.ps1` will adjust the file for you.

The following example assumes the OpenOCD tool was installed in the default location. Adjust the path as required if you used a custom install path to OpenOCD.

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "ESP32 nanoCLR - OLimex OCD-H",
            "type": "cppdbg",
            "request": "launch",
            "MIMode": "gdb",
            "miDebuggerPath": "C:/ESP32_Tools/xtensa-esp32-elf/bin/xtensa-esp32-elf-gdb.exe",
            "stopAtEntry":true,
            "program": "<absolute-path-to-the-build-folder-mind-the-forward-slashes>/targets/FreeRTOS/ESP32_DevKitC/nanoCLR.elf",

            "setupCommands": [
                {"text": "set logging on"},
                {"text": "target extended-remote localhost:3333"},
                {"text": "file <absolute-path-to-the-build-folder-mind-the-forward-slashes>/nanoCLR.elf"},
                {"text": "monitor reset halt"},
                {"text": "thb app_main"},
                {"text": "x $a1=0"}
            ],

            "launchCompleteCommand": "exec-run",
            "debugServerPath": "C:/Esp32_Tools/openocd-esp32/bin/openocd.exe",
            "debugServerArgs": "-s \"C:/Esp32_Tools/openocd-esp32/share/openocd/scripts/\" -f interface/ftdi/olimex-arm-usb-ocd-h.cfg -f target/esp32.cfg -c \"adapter_khz 3000\" " ,
            "serverStarted": "Info : .*Tensilica.*0x1.",
            "filterStderr": true,
            "externalConsole": true,
            "cwd": "${cwd}",

            "logging": {
                "trace": true,
                "traceResponse": true,
                "engineLogging": true,
                "programOutput": true,
                "exceptions": true,
                "moduleLoad": true
            }
        }
    ]
}
```

You can now debug nanoCLR on the ESP32 by pressing F5 in Visual Studio Code.

## Notes on JTAG debugging on ESP32

The JTAG connections on ESP32 DEVKITC are:

- TDI -> GPIO12
- TCK -> GPIO13
- TMS -> GPIO14
- TDO -> GPIO15
- TRST -> EN / RST (Reset)
- GND -> GND

See Gojimmypi for description of JTAG connections [here](https://gojimmypi.blogspot.com/2017/03/jtag-debugging-for-esp32.html).

If flashing nanoCLR via a COM port (default), then be aware that you need to disconnect the JTAG to avoid it preventing the bootloader from running, and therefore being unable to reprogram the ESP23. e.g. if you see the following pattern repeating, unplug the USB-OCD-H, and then the programming will proceed.

```txt
esptool.py v2.1
Connecting........_____....._____...
```

The Esp32 only has 2 hardware breakpoints.

As code is dynamically loaded unless the method has an `IRAM_ATTR` attribute any breakpoints set up at the start will cause an error when you try to debug (Unable to set breakpoint). When launched the debugger will normally stop at the main task. Its not possible to set a break point on code that is not yet loaded so either step down to a point that it is loaded or temporarily set the method with the IRAM_ATTR attribute.

For more information on JTAG debugging see [Espressif documentation](http://esp-idf.readthedocs.io/en/latest/api-guides/jtag-debugging/).

## Debugging nanoCLR without special hardware

If you do not have access to any special hardware required for debug methods mentioned above you still may use some old-school technique: just place some temporary code at interesting places to get the required information. Using steps below you will get that information in Visual Studio's standard debug output window.
Certainly Visual Studio must be debugging something to have that window in working state. So this hack will work only in cases when 
you want to debug a nanoCLR code which can be executed via managed code.

1. Write some managed code which results in a nanoCLR call executing the code you are interested in.
2. Choose one or more places in nanoCLR code where you want to know something.
   e.g.: What is the value of a variable? Which part of an if-else statement gets executed?
3. Put the following temporary code there:

```cpp
        {
            char temporaryStringBuffer[64];
            int realStringSize=snprintf(temporaryStringBuffer, sizeof(temporaryStringBuffer), "interestingValue: %d\r\n", interestingValue);
            CLR_EE_DBG_EVENT_BROADCAST( CLR_DBG_Commands_c_Monitor_Message, realStringSize, temporaryStringBuffer, WP_Flags_c_NonCritical | WP_Flags_c_NoCaching );
        }
```
   Or simly:
```cpp
        CLR_EE_DBG_EVENT_BROADCAST( CLR_DBG_Commands_c_Monitor_Message, 12, "Hello World!", WP_Flags_c_NonCritical | WP_Flags_c_NoCaching );
```

4. The boring part: rebuild and reflash firmware and your program.
5. Start debugging in Visual Studio and keep eye on it's debug output window. 
   You will get your messages there when the related temporary code gets executed!
6. Iterate steps 2-5 till you find out what you were interested in.
7. Do not forget to remove all those temporary code blocks before you accidentally commit it!
