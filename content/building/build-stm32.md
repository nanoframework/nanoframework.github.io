# How to Build, Flash and Debug the STM32 nanoBooter and nanoCLR on Windows using Visual Studio Code

## Table of contents

- [Prerequisites](#prerequisites)
- [Setting up the build environment for STM32](#Setting-up-the-build-environment-for-STM32)
- [Overview](##Overview)
- [nanoFramework Github Repo](#.NET **nanoFramework**-GitHub-repo)
- [Setting up the build environment](#setting-up-the-build-environment)
- [Set up Visual Studio Code](#Set-up-Visual-Studio-Code)
- [Build nanoCLR](#build-nanoclr)
- [Flash the STM32 target](#Flash-the-STM32-target)
- [Next Steps](#Next-Steps)

**About this document**

This document describes how to build the required images for .NET **nanoFramework** for STM32 targets.
The build is based on CMake tool to ease the development in all major platforms.

## Prerequisites

You'll need:

- [Visual Studio Code](http://code.visualstudio.com/)
- Visual Studio Code Extensions
  . [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) - C/C++ IntelliSense, debugging, and code browsing (by Microsoft)
  . [CMake](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) - language support for Visual Studio Code (by Microsoft)
  . [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) - Extended CMake support in Visual Studio Code (by Microsoft)
- [CMake](https://cmake.org/download/) (Minimum required version is 3.15)
- A build system for CMake to generate the build files to. We recommend [Ninja](https://github.com/ninja-build/ninja/releases).
- [GNU ARM Embedded Toolchain](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads)
- OpenOCD (any working distribution will work, some suggestions follow)\
  . [xPack OpenOCD](https://xpack.github.io/openocd/install/#manual-install)
  . [OpenOCD – Open On-Chip Debugger](https://sourceforge.net/projects/openocd/)
- [ChibiOS](http://www.chibios.org/dokuwiki/doku.php) - Technically you do not need to download this, the build scripts will do this automatically if you do not specify a path to ChibiOS in the `cmake-variants.json` (more info [here](#Set-up-Visual-Studio-Code)).

All the the above can be installed by the Power Shell script `.\install-nf-tools.ps1 -TargetSeries STM32` from the `install-scripts` folder within the [`nf-interpreter`](https://github.com/nanoFramework/nf-interpreter) project (cloned or downloaded). If you prefer you can do it manually (NOT RECOMMENDED for obvious reasons).

## Overview

To simplify: this guide we will put all our tools and source in easily accessible folders and not at the default install paths (you do not have to do the same).

1. Create a directory structure such as the following:

   - `C:\nftools`
   - `C:\nanoFramework`

1. Download and install [Visual Studio Code](http://code.visualstudio.com).

1. Clone [`nf-interpreter`](https://github.com/nanoframework/nf-interpreter) repository into `C:\nanoFramework\nf-interpreter`. See next section for more info.

1. Run the PowerShell script that's on the `install-scripts` folder that will download and install all the required tools.
  `.\install-nf-tools.ps1 -TargetSeries STM32 -Path 'C:\nftools'`
   For best results, run in an elevated command prompt, otherwise setting system environnement variables will fail.
1. Review and adjust several JSON files to match your environment (as documented below)
1. Restart Visual Studio Code (due to json changes)

The setup is a lot easier than it seems. The setup scripts do almost everything.

## .NET **nanoFramework** GitHub repo

If you intend to change the nanoBooter or nanoCLR and create Pull Requests then you will need to fork the [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) to your own GitHub repo and clone the forked GitHub repo to your Windows system using an Git client such as the [GitHub Desktop application](https://desktop.github.com/).

The _develop_ branch is the default working branch. When working on a fix or experimenting a new feature you should do it on another branch. See the [Contributing guide](../contributing/contributing-workflow.md#suggested-workflow) for specific instructions on the suggested contributing workflow.

If you don't intend to make changes to the nanoBooter and nanoCLR, you can clone [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) directly from here.

Make sure to put this folder high enough on your drive, that you won't trigger long filename issues. CMake does not support filenames in excess of 250 characters.

## Setting up the build environment

After cloning the repo, you need to setup the build environment. You can use the power shell script or follow the step-by-step instructions.

### Automated Install of the build environment

__The following power shell script is not signed. Run Power Shell as an Administrator and run `set-executionpolicy remotesigned` to enable execution of the non-signed script.__

On Windows, one may use the `.\install-nf-tools.ps1` Power Shell script located in the repository `install-scripts` folder to download/install CMake, the toolchain, OpenOCD (for JTAG debugging) and Ninja. You may need to use __Run as Administrator__ for power shell to permit installing modules to unzip the downloaded archives.
The script will download the zips and installers into the repository `zips` folder and extract them into sub-folders of the nanoFramework tools folder `C:\nftools` or install the tool.

1. Open Power Shell in the `install-scripts` folder of the repository and run the script.

Example Power Shell command line:

    ```ps
    .\install-nf-tools.ps1 -TargetSeries STM32
    ```
  You can force the environment variables to be updated by adding `-Force` to the command line.

The script will create the following sub-folders (see manual install below):

- `C:\nftools`
- `C:\nftools\GNU_Tools_ARM_Embedded\8-2019-q3-update`
- `C:\nftools\ninja`  
- `C:\nftools\hex2dfu`  
- `C:\nftools\openocd`  

The following Environment Variables will be created for the current Windows User.

- `NF_TOOLS_PATH = C:\nftools`
- `GNU_GCC_TOOLCHAIN_PATH = C:\nftools\GNU_Tools_ARM_Embedded\8-2019-q3-update`
- `HEX2DFU_PATH = C:\nftools\hex2dfu`
- `NINJA_PATH = C:\nftools\ninja`

## Set up Visual Studio Code

1. Install the extensions:

    - [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
    - [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools)

1.  Run the PowerShell script `Initialize-VSCode.ps1` that's on the `install-scripts` folder. This will adjust the required settings, build launch configuration for debugging and setup the tasks to ease your developer work.

    ```ps
    .\Initialize-VSCode.ps1
    ```
    You can force the environment variables to be updated by adding `-Force` to the command line.
    The PowerShell relies on the environment variables described above to properly setup the various VS Code working files. In case you have not used the automated install and the variable are not available you'll have to manually edit `tasks.json`, `launch.json`, `cmake-variants.json` and `settings.json` to replace the relevant paths.
    
1. Save any open files and exit VS Code.

## Build nanoCLR

1. Launch Visual Studio from the repository folder, or load it from the __File__ menu, select __Open Folder__ and browse to the repo folder. VS Code could prompt you asking "Would you like to configure this project?". Ignore the prompt as you need to select the build variant first.

1. Reopen VS Code. It should load the workspace automatically. In the status bar at the bottom left, click on the `No Kit Selected` and select `[Unspecified]`.

1. In the status bar at the bottom left, click on the `CMake:Debug ST_STM32F429I_DISCOVERY: Ready` and select `Debug`. Wait for it to finish Configuring the project (progress bar shown in right bottom corner). This can take a while the first time. 

1. In the status bar click `Build` or hit F7.

1. Wait for the build to finish with `Build finished with exit code 0` output message.

1. In the `build` folder you'll find several files:

    - `nanoBooter.bin`
    - `nanoBooter.elf`
    - `nanoBooter.hex`
    - `nanoCLR.bin`
    - `nanoCLR.elf`
    - `nanoCLR.hex`
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

## Flash the STM32 target

There are two options to flash the nanoBooter & nanoCLR images to a target. The first one uses the C/C++ tools in VS Code along with OpenOCD. This is the way to do it if you're planning to debug the code. The second uses a stand alone tool from STM that _just_ flashes the images into the target. Useful if you don't plan to do any debugging.  

### Starting a debug session in VS Code

1. Assuming that you have a valid `launch.json` configuration for the target that you've build, you can go to the Run section.

1. Choose the launch configuration for nanoBooter corresponding to your target.

1. Click on the `Start Debugging` (green arrow).
  (this will flash the nanoBooter into the target's flash memory)

1. Stop the debug session.

1. Choose the launch configuration for nanoCLR corresponding to your target.

1. Click on the `Start Debugging` (green arrow).
  (this will flash the nanoBooter into the target's flash memory)

1. Stop the debug session.

>>Note: You don't have to re-flash nanoBooter every time you flash nanoCLR as it won't be erased.


### Using STM32 ST-LINK Utility

1. Download the [STM32 ST-LINK Utility](https://www.st.com/content/st_com/en/products/development-tools/software-development-tools/stm32-software-development-tools/stm32-programmers/stsw-link004.html) from ST web site and install it in your development machine.

1. Connect the Target board to your PC using an USB cable.

1. Open STM32 ST-Link Utility. And click on `Target > Connect`.

1. Next erase the entire chip by clicking on `Target > Erase Chip`.

1. Open `nanoBooter.hex` (`Open > Open File...`) and program and verify (`Target > Program & Verify...`). Make sure you tick the `Reset after programming` check box and hit `Start`. After the upload completes, the MCU is reset and the nanoBooter image runs. You can check the success of the operation watching for a slow blink pattern on the LED. Congratulations, you now have a board running nanoFramework's booter!

1. Open `nanoCLR.hex` (`Open > Open File...`) and program and verify (`Target > Program & Verify...`). Make sure you tick the `Reset after programming` check box and hit `Start`. After the upload completes, the MCU is reset and the nanoCLR image will run. This time and if all goes as expected, there will be no LED blinking.
>>Note: You don't have to re-flash nanoBooter every time you flash nanoCLR.

## Next Steps

See [Getting Started](http://docs.nanoframework.net/content/getting-started-guides/getting-started-managed.html) for instructions on creating and running a 'Hello World' managed application on your nanoFramework board.
