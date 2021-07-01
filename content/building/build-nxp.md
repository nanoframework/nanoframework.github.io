# How to Build, Flash and Debug the NXP nanoBooter and nanoCLR on Windows using Visual Studio Code

## About this document

This document describes how to build the required images for .NET **nanoFramework** for NXP targets.
The build is based on CMake tool to ease the development in all major platforms.

## Using Dev Container

If you want a simple, efficient way, we can recommend you to use [Dev Container](using-dev-container.md) to build your image. This has few requirements as well like Docker Desktop and Remote Container extension in VS Code but it is already all setup and ready to run!

If you prefer to install all the tools needed on your Windows machine, you should continue this tutorial.

## Prerequisites

You'll need:

- [Visual Studio Code](http://code.visualstudio.com/)
- Visual Studio Code Extensions
  . [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) - C/C++ IntelliSense, debugging, and code browsing (by Microsoft)
  . [CMake](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) - language support for Visual Studio Code (by Microsoft)
  . [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) - Extended CMake support in Visual Studio Code (by Microsoft)
  . [Cortex Debug](https://marcelball.ca/projects/cortex-debug/) - Debug tool made explicity for ARM Cortex-M cores (needed for J-Link), if you're using on board programmer you don't need it.
- [CMake](https://cmake.org/download/) (Minimum required version is 3.15)
- A build system for CMake to generate the build files to. We recommend [Ninja](https://github.com/ninja-build/ninja/releases).
- [GNU ARM Embedded Toolchain](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads)
- OpenOCD. Suggest the [xPack OpenOCD](https://github.com/xpack-dev-tools/openocd-xpack/releases) that kindly maintains a Windows distribution.
- [ChibiOS](http://www.chibios.org/dokuwiki/doku.php) - Technically you do not need to download this, the build scripts will do this automatically if you do not specify a path to ChibiOS in the `cmake-variants.json` (more info [here](#Set-up-Visual-Studio-Code)).

All the above can be installed by the Power Shell script `.\install-nf-tools.ps1 -TargetSeries NXP` from the `install-scripts` folder within the [`nf-interpreter`](https://github.com/nanoFramework/nf-interpreter) project (cloned or downloaded). If you prefer you can do it manually (NOT RECOMMENDED for obvious reasons).

## Overview

To simplify: this guide we will put all our tools and source in easily accessible folders and not at the default install paths (you do not have to do the same).

1. Create a directory structure such as the following:

   - `C:\nftools`
   - `C:\nanoFramework`

1. Download and install [Visual Studio Code](http://code.visualstudio.com).

1. Clone [`nf-interpreter`](https://github.com/nanoframework/nf-interpreter) repository into `C:\nanoFramework\nf-interpreter`. See next section for more info.

1. Run the PowerShell script that's on the `install-scripts` folder that will download and install all the required tools.
  `.\install-stm32-tools.ps1 -Path 'C:\nftools'`
   For best results, run in an elevated command prompt, otherwise setting system environnement variables will fail.
1. Review and adjust several JSON files to match your environment (as documented below)
1. Restart Visual Studio Code (due to json changes)

The setup is a lot easier than it seems. The setup scripts do almost everything.

## .NET **nanoFramework** GitHub repo

If you intend to change the nanoBooter or nanoCLR and create Pull Requests then you will need to fork the [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) to your own GitHub repo and clone the forked GitHub repo to your Windows system using an Git client such as the [GitHub Desktop application](https://desktop.github.com/).

The _develop_ branch is the default working branch. When working on a fix or experimenting a new feature you should do it on another branch. See the [Contributing guide](../contributing/contributing-workflow.md#suggested-workflow) for specific instructions on the suggested contributing workflow.

If you don't intend to make changes to the nanoBooter and nanoCLR, you can clone [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) directly from here.

Make sure to put this folder high enough on your drive, that you won't trigger long filename issues. CMake does not support filenames in excess of 250 characters.

## Setting up the build environment in Windows

To simplify, this guide we will put all our tools and source in easily accessible folders and not at the default install paths (you do not have to do the same):

1. Create a directory structure such as the following:

   - `C:\nftools`
   - `C:\nanoFramework`

2. [Download](http://code.visualstudio.com/) and install Visual Studio Code.

3. [Download](https://cmake.org/download/) and install CMake to `C:\nftools\CMake`.

4. [Download](https://github.com/ninja-build/ninja/releases) Ninja and place the executable in `C:\nftools\Ninja`.

5. [Download](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads) and install the GNU ARM Embedded Toolchain to `C:\nftools\GNU_ARM_Toolchain`.

6. Finally, clone `nf-interpreter` into `C:\nanoFramework\nf-interpreter`. See next section for more info.

### Set up MCUXpresso IDE

For programming eval board using on board LPC-Link programmer you will need to set up MCUXpresso IDE which provides us with redlink software. Redlink copies flash image to core RAM and from there it's flashed into external HyperFlash or QSPI flash.

1. Register and download MCUXpresso IDE form nxp [website](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=2ahUKEwiPwZiTlMHmAhU5AxAIHQkrDNIQFjAAegQIBhAB&url=https%3A%2F%2Fwww.nxp.com%2Fdesign%2Fsoftware%2Fdevelopment-software%2Fmcuxpresso-software-and-tools%2Fmcuxpresso-integrated-development-environment-ide%3AMCUXpresso-IDE&usg=AOvVaw0Oh8kETGeCSOnWTlKyGj_I).
1. Install MCUXpresso IDE.
1. Remember to set proper paths while setting up `launch.json` file in next steps.

## Setting up the build environment

After cloning the repo, you need to setup the build environment. You can use the power shell script or follow the step-by-step instructions.

### Automated Install of the build environment

__Run Power Shell as an Administrator and run `set-executionpolicy RemoteSigned` to enable execution of the signed script.__

On Windows, one may use the `.\install-nf-tools.ps1` Power Shell script located in the repository `install-scripts` folder to download/install CMake, the toolchain, OpenOCD (for JTAG debugging) and Ninja. You may need to use __Run as Administrator__ for power shell to permit installing modules to unzip the downloaded archives.
The script will download the zips and installers into the repository `zips` folder and extract them into sub-folders of the nanoFramework tools folder `C:\nftools` or install the tool.

1. Open Power Shell in the `install-scripts` folder of the repository and run the script.

Example Power Shell command line:

```ps
.\install-nf-tools.ps1 -TargetSeries NXP
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
- `NINJA_PATH = C:\nftools\ninja`

## Set up Visual Studio Code

- **Step1**: Install the extensions:

  - [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
  - [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools)

- **Step2**: Run the PowerShell script `Initialize-VSCode.ps1` that's on the `install-scripts` folder. This will adjust the required settings, build launch configuration for debugging and setup the tasks to ease your developer work.

```ps
  .\Initialize-VSCode.ps1
```

You can force the environment variables to be updated by adding `-Force` to the command line.
The PowerShell relies on the environment variables described above to properly setup the various VS Code working files. In case you have not used the automated install and the variable are not available you'll have to manually edit `tasks.json`, `launch.json`, `cmake-variants.json` and `settings.json` to replace the relevant paths.

- **Step3**: If you want to use onboard programmer edit the file named `settings.json` inside the `.vscode` folder and paste the following (mind to update the path to your setup).

```json
{
    "cortex-debug.armToolchainPath": "c:/nftools/GNU_ARM_Toolchain/8 2019-q3-update/bin",
    "cortex-debug.JLinkGDBServerPath": "c:/Program Files (x86)/SEGGER/JLink/JLinkGDBServerCL.exe"
}
```

- **Step4**: Save any open files and exit VS Code.

## Build nanoCLR

- **Step1**: Launch Visual Studio from the repository folder, or load it from the __File__ menu, select __Open Folder__ and browse to the repo folder. VS Code could prompt you asking "Would you like to configure this project?". Ignore the prompt as you need to select the build variant first.

- **Step2**: Reopen VS Code. It should load the workspace automatically. In the status bar at the bottom left, click on the `No Kit Selected` and select `[Unspecified]`.

- **Step3**: In the status bar at the bottom left, click on the `CMake:Debug NXP_MIMXRT1060_EVK: Ready` and select `Debug`. Wait for it to finish Configuring the project (progress bar shown in right bottom corner). This can take a while the first time.

- **Step4**: In the status bar click `Build` or hit F7.

- **Step5**: Wait for the build to finish with `Build finished with exit code 0` output message.

- **Step6**: In the `build` folder you'll find several files:
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

## Flash the NXP target

1. Connect the Target board to your PC using an USB cable.
1. Open Visual Studio Code and go to `Debug and Run` (CTRL+SHIFT+D).
1. Run debug (green rectangle or F5 default shortcut), firstly on nanoBooter then nanoCLR.
    >>Note: You don't have to re-flash nanoBooter every time you flash nanoCLR.

## Debugging with Cortex Debug with J-Link (Optional)

If you want to view CPU register values in real time and use more advanced debugging tool. It's possible to use Cortex Debug extension. Please refer to guides available at SEGGER's wiki.

## Next Steps

See [Getting Started](http://docs.nanoframework.net/content/getting-started-guides/getting-started-managed.html) for instructions on creating and running a 'Hello World' managed application on your nanoFramework board.
