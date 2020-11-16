# How to Build, Flash and Debug the ESP32 nanoCLR on Windows using Visual Code

## Table of contents

- [Prerequisites](#prerequisites)
- [Overview](#overview)
- [nanoFramework Github Repo](#**nanoFramework**-GitHub-repo)
- [Setting up the build environment](#setting-up-the-build-environment)
- [Set up Visual Studio Code](#set-up-visual-studio-code)
- [Build nanoCLR](#build-nanoclr)
- [Common Build Issues](#common-build-issues)
- [Flash nanoCLR to ESP32](#flash-nanoclr-into-esp32)
- [Start with a Hello World C# application](#start-with-a-hello-world-c-application)
- [Debug the nanoCLR](#debugging-nanoclr)

**About this document**

This document describes how to build the required images for .NET **nanoFramework** for ESP32 targets.
The build is based on CMake tool to ease the development in all major platforms.

## Prerequisites

You'll need:

- [Visual Studio Code](http://code.visualstudio.com/). Additional extensions and setup steps follow below. [Set up Visual Code](#Set-up-Visual-Code)
- [Python 3.6.5](https://www.python.org/ftp/python/3.6.5/python-3.6.5.exe) Required for uploading the nanoCLR to the ESP32.
  - Ensure the Windows default app to open `.py` files is Python.
- [CMake](https://cmake.org/download/) (Minimum required version is 3.15)
- A build system for CMake to generate the build files to. We recommend [Ninja](https://github.com/ninja-build/ninja/releases).
- [OpenOCD](https://github.com/espressif/openocd-esp32/releases/download/v0.10.0-esp32-20180418/openocd-esp32-win32-0.10.0-esp32-20180418.zip) For on chip debugging of the nanoCLR.
- Driver for the USB to UART Bridge. This depends on the ESP32 hardware. After installing it, use Windows Device Manager to determine the COM port as this is needed to complete the setup. Follows the most common drivers:
  - [CP210x USB to UART Bridge VCP Drivers](https://www.silabs.com/products/development-tools/software/usb-to-uart-bridge-vcp-drivers) used in the standard ESP32 DevKitC.
  - [FTDI Virtual COM Port Drivers](https://www.ftdichip.com/Drivers/VCP.htm).

All the above can be installed using the Power Shell script `.\install-nf-tools.ps1 -TargetSeries ESP32` from the `install-scripts` folder within the [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) project (cloned or downloaded). If you prefer you can do it [manually](#Manual-Install-of-the-build-environment-for-ESP32) (NOT RECOMMENDED for obvious reasons).

## Overview

To simplify: this guide we will put all our tools and source in easily accessible folders and not at the default install paths (you do not have to do the same).

1. Create a directory structure such as the following:

   - `C:\nftools`
   - `C:\nanoFramework`

1. Download and install [Visual Studio Code](http://code.visualstudio.com).

1. Clone [`nf-interpreter`](https://github.com/nanoframework/nf-interpreter) repository into `C:\nanoFramework\nf-interpreter`. See next section for more info.

1. Run the PowerShell script that's on the `install-scripts` folder that will download and install all the required tools.
  `.\install-nf-tools.ps1 -TargetSeries ESP32 -Path 'C:\nftools'`
   For best results, run in an elevated command prompt, otherwise setting system environnement variables will fail.
1. Review and adjust several JSON files to match your environment (as documented below)
1. Restart Visual Studio Code (due to json changes)

The setup is a lot easier than it seems. The setup scripts do almost everything.

## .NET **nanoFramework** GitHub repo

If you intend to change the nanoCLR and create Pull Requests then you will need to fork the [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) to your own GitHub repo and clone the forked GitHub repo to your Windows system using an Git client such as [Fork](https://fork.dev) or the [GitHub Desktop application](https://desktop.github.com).

The _develop_ branch is the default working branch. When working on a fix or experimenting a new feature you should do it on another branch. See the [Contributing guide](..\..\content\contributing\contributing-workflow.md#suggested-workflow) for specific instructions on the suggested contributing workflow.

If you don't intend to make changes to the nanoBooter and nanoCLR, you can clone [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) directly from here.

Make sure to put this folder high enough on your drive, that you won't trigger long filename issues. CMake does not support filenames in excess of 250 characters.

## Setting up the build environment

After cloning the repo, you need to setup the build environment. You can use the power shell script or follow the step-by-step instructions.

### Automated Install of the build environment

__The following power shell script is not signed. Run Power Shell as an Administrator and run `set-executionpolicy remotesigned` to enable execution of the non-signed script.__

On Windows, one may use the `.\install-nf-tools.ps1` Power Shell script located in the repository `install-scripts` folder to download/install CMake, the ESP32 IDF Source, toolchain, prebuilt libraries, OpenOCD (for JTAG debugging) and Ninja. You may need to use __Run as Administrator__ for power shell to permit installing modules to unzip the downloaded archives.
The script will download the zips and installers into the repository `zips` folder and extract them into sub-folders of the nanoFramework tools folder `C:\nftools` or install the tool [manually](#Manual-Install-of-the-build-environment-for-ESP32).

1. Open Power Shell in the `install-scripts` folder of the repository.

    Example Power Shell command line:

    ```ps
    .\install-nf-tools.ps1 -TargetSeries ESP32
    ```
    You can force the environment variables to be updated by adding `-Force` to the command line.
        
    The script will create the following sub-folders (see manual install below):
    
    - `C:\nftools`
    - `C:\nftools\esp-idf-v3.3.1`
    - `C:\nftools\libs-v3.3.1`
    - `C:\nftools\ninja`  
    - `C:\nftools\openocd-esp32`  
    
    The following Environment Variables will be created for the current Windows User.
    
    - `NF_TOOLS_PATH = C:\nftools`
    - `ESP32_TOOLCHAIN_PATH = C:\nftools\xtensa-esp32-elf`
    - `ESP32_LIBS_PATH = C:\nftools\libs-v3.3.1`
    - `IDF_PATH = C:\nftools\esp-idf-v3.3.1`
    - `NINJA_PATH = C:\nftools\ninja`
    
### Manual Install of the build environment

These steps are **not** required if you've used the automated install script as described above.

To save time on building the nanoCLR and to avoid having to create a CMakeLists.txt project for the ESP32 IDF files, the ESP32 IDF libraries are prebuilt using the Esp32 Msys32 environment then used for linking in the CMake build of nanoCLR.
This has already been done and the libraries can be just be downloaded.

1. Create a directory such as the following:

   - `C:\nftools`
   - `C:\nftools\libs-v3.3.1`

1. Download the pre-built libs zip from [here](https://bintray.com/nfbot/internal-build-tools/download_file?file_path=IDF_libs-v3.3.1.zip) and extract it into `C:\nftools\libs-v3.3.1`.

1. Download the v3.3.1 IDF source zip file from [here](https://dl.espressif.com/dl/esp-idf/releases/esp-idf-v3.3.1.zip) and extract it into `C:\nftools` so you get `C:\nftools\esp-idf-v3.3\components` etc.

1. Download the Esp32 toolchain from [here](https://dl.espressif.com/dl/xtensa-esp32-elf-win32-1.22.0-80-g6c4433a-5.2.0.zip) and extract it into `C:\nftools` so you get `C:\nftools\xtensa-esp32-elf`.

1. For on chip debugging of the nanoCLR, download OpenOCD from [here](https://github.com/espressif/openocd-esp32/releases/download/v0.10.0-esp32-20180724/openocd-esp32-win32-0.10.0-esp32-20180724.zip) and extract OpenOCD into `C:\nftools` so you get `C:\nftools\openocd-esp32`.

1. Download the light weight build system Ninja for CMake to generate the build files from [here](https://github.com/ninja-build/ninja/releases/). This is lightweight build system, designed for speed and it works on Windows and Linux machines. See [here](../building/cmake/ninja-build.md) how to setup Ninja to build .NET **nanoFramework**.
  
1. Define the environment variables to match the install locations. Default locations are:
   - `ESP32_TOOLS_PATH = C:\nftools`
   - `ESP32_TOOLCHAIN_PATH = C:\nftools\xtensa-esp32-elf`
   - `ESP32_LIBS_PATH = C:\nftools\libs-v3.3.1`
   - `IDF_PATH = C:\nftools\esp-idf-v3.3.1`
   - `NINJA_PATH = C:\nftools\ninja`

1. Add Ninja to the PATH (i.e. `C:\nftools\ninja`)

1. Download the latest stable version from [here](https://cmake.org/download/) and install it.

1. Install [Python 3.6.5](https://www.python.org/ftp/python/3.6.5/python-3.6.5.exe) and then install the serial driver for python from the command line:
    
    ```cmd
    python -m pip install pyserial
    ```
    Note that `.\install-esp32-tools.ps1` will install `pyserial` for you if you installed Python prior to running the script. (It is Ok to run `python -m pip install pyserial` multiple times.)

## Set up Visual Studio Code

1. Install the extensions:

    - [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
    - [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools)

1.  Run the PowerShell script `Initialize-VSCode.ps1` that's on the `install-scripts` folder. This will adjust the required settings, build launch configuration for debugging and setup the tasks to ease your developer work.

    ```ps
    .\Initialize-VSCode.ps1
    ```
    
    - You can force the environment variables to be updated by adding `-Force` to the command line.
    - The PowerShell relies on the environment variables described above to properly setup the various VS Code working files. In case you have not used the automated install and the variable are not available you'll have to manually edit `tasks.json`, `launch.json`, `cmake-variants.json` and `settings.json` to replace the relevant paths. **!!mind to always use forward slashes in the paths!!**
    - More info available on the [Tweaking cmake-variants.TEMPLATE.json](../building/cmake-tools-cmake-variants.md) documentation page.
    
1. Save any open files and **RESTART** VS Code. Have you **RESTARTED** VS Code? You really have to do it otherwise this won't work.

## Build nanoCLR

1. Launch Visual Studio from the repository folder, or load it from the __File__ menu, select __Open Folder__ and browse to the repo folder. VS Code could prompt you asking "Would you like to configure this project?". Ignore the prompt as you need to select the build variant first.
Next time VS Code open it should load the workspace automatically. 

1. In the status bar at the bottom left, click on the `No Kit Selected` and select `[Unspecified]`.

1. In the status bar at the bottom left, click on the `CMake:Debug ESP32_WROOM_32: Ready` and select `Debug`. Wait for it to finish Configuring the project (progress bar shown in right bottom corner). This can take a while the first time.

1. In the status bar click `Build` or hit F7.

1. Wait for the build to finish with `Build finished with exit code 0` output message.

1. In the `build` folder you'll find several files:
    - `nanoCLR.bin`
    - `nanoCLR.elf`
    - `partitions_4mb.elf`

>> Note: If there are errors during the build process it is possible to end up with a partial build in the `build` folder, and the `CMake/Ninja` build process declaring a successful build despite the `.bin` targets not being created, and a `CMake clean` not helping.
In this case deleting the contents of the `build` folder should allow the build to complete once you resolve the issues that cause the original failure.

### Common Build Issues

The above may have some errors if:
- CMake is not installed properly, not in the PATH or cannot be found for some reason.
- Ninja is not recognized: check settings.json or your PATH environment variable and restart Visual Studio Code. 
- COMPILATION object file not found: check that your paths don't exceed 140 chars. Put the solution folder high enough on drive.
- Make sure to 'Build all' first time.
- Reopen VS Code if you have changed anything on the `cmake-variants.json`.
- Clean the build folder by deleting it's contents and restart VS Code.

## Flash nanoCLR into ESP32

1. The third file that gets flashed into the ESP32 is the `bootloader.bin` which will be located here `C:/nftools/libs-v3.3.1/bootloader.bin` if the automated install script is used.

1. Connect your development board.

1. Some ESP32 boards require to be put into "download mode". Most don't even need this. Check the documentation for your variant. One of the most common options are: hold down the GPIO0 pin to GND or holding down the respective button during power up.

1. In Visual Studio Code go to menu "Terminal" -> "Run Task" and select "Flash nanoCLR to ESP32 from the list.

1. As an alternative enter the command in command palette:

    ```cmd
    Tasks: Run task
    ```

    and if you flash the board for the first time

    ```cmd
    Erase ESP32
    ```

    and then

    ```cmd
    Flash nanoCLR to ESP32
    ```

    it will ask you for the COM port where it's connected

## Start with a 'Hello World' C# application

Watch the video tutorial [here](https://youtu.be/iZdN2GmefXI) and follow the step that should be done in Visual Studio 2017 Community Edition. Skip the steps that describing uploading the nanoCLR into the STM32 Nucleo board.

## Debugging nanoCLR

If you want to debug the nanoCLR code on the ESP32 chip you'll need an JTAG debugging adapter. ESP32 WROVER KIT already includes one. For other boards you can use the Olimex ARM-USB-OCD-H JTAG debugging adapter or a Segger JLink. There are preset configurations for these adapters.

You can now debug nanoCLR on the ESP32 by pressing F5 in Visual Studio Code.

### Notes on JTAG debugging on ESP32

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

### Debugging nanoCLR without special hardware

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
   Or simply:
```cpp
        CLR_EE_DBG_EVENT_BROADCAST( CLR_DBG_Commands_c_Monitor_Message, 12, "Hello World!", WP_Flags_c_NonCritical | WP_Flags_c_NoCaching );
```

4. The boring part: rebuild and re-flash firmware and your program.
5. Start debugging in Visual Studio and keep eye on it's debug output window. 
   You will get your messages there when the related temporary code gets executed!
6. Iterate steps 2-5 till you find out what you were interested in.
7. Do not forget to remove all those temporary code blocks before you accidentally commit it!
