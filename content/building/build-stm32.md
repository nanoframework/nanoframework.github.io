# How to Build, Flash and Debug the STM32 nanoBooter and nanoCLR on Windows using Visual Studio Code

⚠️ NOTE about the need to build .NET **nanoFramework** firmware ⚠️

You only need to build it if you plan to debug the CLR, interpreter, execution engine, drivers, add new targets or add new features at native level.
If your goal is to code in C# you just have to flash your MCU with the appropriate firmware image using [nanoff](https://github.com/nanoframework/nanoFirmwareFlasher).
There are available ready to flash firmware images for several targets, please check the [Home](https://github.com/nanoframework/Home#firmware-for-reference-boards) repository.

## About this document

This document describes how to build the required images for .NET **nanoFramework** firmware for STM32 targets.
The build system is based on CMake tool to ease the development in all major platforms.

## Using Dev Container

If you want a simple, efficient way, we can recommend you to use [Dev Container](using-dev-container.md) to build your image. This has few requirements as well like Docker Desktop and Remote Container extension in VS Code but it is already all setup and ready to run!

If you prefer to install all the tools needed on your Windows machine, you should continue this tutorial.

## Prerequisites

You'll need:

- [Visual Studio Code](https://code.visualstudio.com/)
- Visual Studio Code Extensions
  . [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) - C/C++ IntelliSense, debugging, and code browsing (by Microsoft)
  . [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) - Extended CMake support in Visual Studio Code (by Microsoft)
- [CMake](https://cmake.org/download/) (Minimum required version is 3.21)
- A build system for CMake to generate the build files to. We recommend [Ninja](https://github.com/ninja-build/ninja/releases).
- [GNU ARM Embedded Toolchain](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads)
- OpenOCD. We suggest [Microsoft build](https://github.com/microsoft/openocd) which provides a Windows distribution including convenient fixes for working with Azure RTOS.
- [ChibiOS](https://www.chibios.org/dokuwiki/doku.php) - Technically you do not need to download this, the build scripts will do this automatically if you do not specify a path to ChibiOS in the `CHIBIOS_SOURCE_FOLDER` build option (more info [here](#set-up-visual-studio-code)).

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
   For best results, run in an elevated command prompt, otherwise setting system environment variables will fail.
1. Review and adjust several JSON files to match your environment (as documented below)
1. Restart Visual Studio Code (due to json changes)

The setup is a lot easier than it seems. The setup scripts do almost everything.

## .NET **nanoFramework** GitHub repo

If you intend to change the nanoBooter or nanoCLR and create Pull Requests then you will need to fork the [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) to your own GitHub repo and clone the forked GitHub repo to your Windows system using an Git client such as the [GitHub Desktop application](https://desktop.github.com/).

The _main_ branch is the default working branch. When working on a fix or experimenting a new feature you should do it on its own branch. See the [Contributing guide](../contributing/contributing-workflow.md#suggested-workflow) for specific instructions on the suggested contributing workflow.

If you don't intend to make changes to the nanoBooter and nanoCLR, you can just clone [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) directly from GitHub.

Make sure to put this folder high enough on your drive, that you won't trigger long filename issues. CMake does not support filenames in excess of 250 characters.

## Setting up the build environment

After cloning the repo, you need to setup the build environment. You can use the power shell script or follow the step-by-step instructions.

### Automated Install of the build environment

**Run Power Shell as an Administrator and run `set-executionpolicy RemoteSigned` to enable execution of the signed script.**

On Windows, one may use the `.\install-nf-tools.ps1` Power Shell script located in the repository `install-scripts` folder to download/install CMake, the toolchain, OpenOCD (for JTAG debugging) and Ninja. You may need to use **Run as Administrator** for power shell to permit installing modules to unzip the downloaded archives.
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

- **Step 1:** Install the extensions:
  - [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
  - [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools)

- **Step 2:** Run the PowerShell script `Initialize-VSCode.ps1` that's on the `install-scripts` folder. This will adjust the required settings, build launch configuration for debugging and setup the tasks to ease your developer work.

```ps
.\Initialize-VSCode.ps1
```

You can force the environment variables to be updated by adding `-Force` to the command line.
The PowerShell relies on the environment variables described above to properly setup the various VS Code working files. In case you have not used the automated install and the variable are not available you'll have to manually edit `tasks.json`, `launch.json` and `settings.json` to replace the relevant paths.

- **Step 3:** Copy the template file (in `nf-interpreter\config` folder) `user-tools-repos.TEMPLATE.json` to a (new) file called `user-tools-repos.json`. Rename the json section `user-tools-repos-local` to `user-tools-repos` and adjust paths for the tools and repositories in the `user-tools-repos` configuration preset. If you don't have the intention to build for a particular platform you can simply remove the related options from there. If you don't want to use local clones of the various repositories you can simply set those to `null`. **!!mind to always use forward slashes in the paths!!**

- **Step 4:** Save any open files and exit VS Code.

## Build nanoCLR

- **Step 1:** Launch Visual Studio Code from the repository folder, or load it from the **File** menu, select **Open Folder** and browse to the repo folder. VS Code could prompt you asking "Would you like to configure this project?". Ignore the prompt as you need to select the build variant first.

- **Step 2:** Reopen VS Code. It should load the workspace automatically. In the status bar at the bottom left, click on the `No Configure Preset Selected` and select the target you want to build from the drop-down list that will open at the top. The respective build preset will be automatically selected by VS Code. More details on this on the documentation about the available targets [here](../reference-targets/index.md).

![choose-preset](../../images/building/vs-code-bottom-tolbar-choose-preset.png)

- **Step 3:** In the status bar click `Build` or hit F7.

- **Step 4:** Wait for the build to finish with `Build finished with exit code 0` output message.

- **Step 5:** In the `build` folder you'll find several files:
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
- Reopen VS Code if you have made changes on the `CMakePresets.json` or `CMakeUserPresets.json`.

A good remedy for most of the build issues is to manually clean the build folder by deleting it's contents and restarting VS Code.

## Flash the STM32 target

There are two options to flash the nanoBooter & nanoCLR images to a target. The first one uses the C/C++ tools in VS Code along with OpenOCD. This is the way to do it if you're planning to debug the code. The second uses a stand alone tool from STM that _just_ flashes the images into the target. Useful if you don't plan to do any debugging.  

### Starting a debug session in VS Code

1. Assuming that you have a valid `launch.json` configuration for the target that you've build, you can go to the Run section.
2. Choose the launch configuration for nanoBooter corresponding to your target.
3. Click on the `Start Debugging` (green arrow).
  (this will flash the nanoBooter into the target's flash memory)
4. Stop the debug session.
5. Choose the launch configuration for nanoCLR corresponding to your target.
6. Click on the `Start Debugging` (green arrow).
  (this will flash the nanoBooter into the target's flash memory)
7. Stop the debug session.

>Note: You don't have to re-flash nanoBooter every time you flash nanoCLR as it won't be erased.

### Using STM32CubeProgrammer Utility

Follow the instructions [here](../stm32/flash-cube-programmer.md) to install STM32CubeProgrammer and flash `nanoBooter.hex` and `nanoCLR.hex` images to the board. Also this is not mandatory as all this can be handled by VS Code.

## Next Steps

See [Getting Started](http://docs.nanoframework.net/content/getting-started-guides/getting-started-managed.html) for instructions on creating and running a 'Hello World' managed application on your nanoFramework board.
