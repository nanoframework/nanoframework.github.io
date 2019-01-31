# How to Build, Flash and Debug the STM32 nanoBooter and nanoCLR on Windows using Visual Studio Code

## Table of contents

- [Prerequisites](#prerequisites)
- [Setting up the build environment for STM32](#Setting-up-the-build-environment-for-STM32)
- [nanoFramework Github Repo](#**nanoFramework**-GitHub-repo)
- [Set up Visual Studio Code](#Set-up-Visual-Studio-Code)
- [Build nanoBooter and nanoCLR](#Build-nanoBooter-and-nanoCLR)
- [Flash the STM32 target](#Flash-the-STM32-target)
- [Next Steps](#Next-Steps)

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
- [CMake](https://cmake.org/download/) (Minimum required version is 3.11)
- A build system for CMake to generate the build files to. 
  . If you have Visual Studio (full version) you can use the included NMake.
  . [Ninja](https://github.com/ninja-build/ninja/releases). This is lightweight build system, designed for speed and it works on Windows and Linux machines. See [here](cmake/ninja-build.md) how to setup Ninja to build **nanoFramework**. This guide will use Ninja.
- [GNU ARM Embedded Toolchain](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads)
- OpenOCD (any working distribution will work, some suggestions follow)\ 
  . [Freddie Chopin OpenOCD](http://www.freddiechopin.info/en/download/category/4-openocd)
  . [OpenOCD – Open On-Chip Debugger](https://sourceforge.net/projects/openocd/)
  . [GNU ARM Eclipse OpenOCD](https://github.com/gnuarmeclipse/openocd)
- [ChibiOS](http://www.chibios.org/dokuwiki/doku.php) - Technically you do not need to download this, the build scripts will do this automatically if you do not specify a path to ChibiOS in the `CMake-variants.json` (more info [here](#Set-up-Visual-Studio-Code)).

## Setting up the build environment for STM32

To simplify, this guide we will put all our tools and source in easily accessible folders and not at the default install paths (you do not have to do the same):

1. Create a directory structure such as the following:

   - `C:\nanoFramework_Tools`
   - `C:\nanoFramework`

2. [Download](http://code.visualstudio.com/) and install Visual Studio Code.

3. [Download](https://cmake.org/download/) and install CMake to `C:\nanoFramework_Tools\CMake`

4. [Download](https://github.com/ninja-build/ninja/releases) Ninja and place the executable in `C:\nanoFramework_Tools\Ninja`

5. [Download](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads) and install the GNU ARM Embedded Toolchain to `C:\nanoFramework_Tools\GNU_ARM_Toolchain`
6. [Download](https://sourceforge.net/projects/chibios/files/) and extract ChibiOS to `C:\nanoframework_tools\ChibiOS-stable_18.2.x`

7. Finally, clone `nf-interpreter` into `C:\nanoFramework\nf-interpreter`. See next section for more info.

## **nanoFramework** GitHub repo

If you intend to change the nanoBooter or nanoCLR for the STM32 target and create Pull Requests then you will need to fork the [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) to your own GitHub repo and clone the forked GitHub repo to your Windows system using an Git client such as the [GitHub Desktop application](https://desktop.github.com/).

See the [Contributing to nanoFramework](https://github.com/nanoframework/Home/blob/master/CONTRIBUTING.md) guide for specific instructions when contributing.

If you don't intend to make changes to the nanoBooter and nanoCLR, you can clone [nanoFramework/nf-interpreter](https://github.com/nanoFramework/nf-interpreter) directly from here.

## Set up Visual Studio Code

1. Install the extensions:

    - [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
    - [CMake](https://marketplace.visualstudio.com/items?itemName=twxs.cmake)
    - [CMake Tools](https://marketplace.visualstudio.com/items?itemName=vector-of-bool.cmake-tools)

2. Set up the `CMake-variants.json` in root directory of your local nanoFramework/nf-interpreter clone.
  
    There is a template file called `cmake-variants.TEMPLATE.json` that can be renamed and configured accordingly.

    More info available on the [Tweaking cmake-variants.TEMPLATE.json](https://github.com/nanoframework/Home/blob/master/docs/building/cmake-tools-cmake-variants.md) documentation page.

    For any of the [Reference target boards](http://docs.nanoframework.net/articles/reference-targets-intro.html) you can find pre-populated template files [here](https://github.com/nanoframework/Home/blob/c2eb47665ed426a000e18858cbdf5d71cb836421/docs/building/cmake-tools-cmake-variants.md#templates).
\
    Here is an example `CMake-variants.json` for the STM32F429I-DISCOVERY:

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

      "ST_STM32F429I_DISCOVERY": {
        "short": "ST_STM32F429I_DISCOVERY",
        "settings": {
          "BUILD_VERSION" : "0.9.99.999",
          "TOOLCHAIN_PREFIX" : "C:/nanoFramework_Tools/GNU_ARM_Toolchain",
          "TARGET_SERIES" : "STM32F4xx",
          "USE_RNG" : "ON",
          "CHIBIOS_SOURCE" : "C:/nanoFramework_Tools/ChibiOS-stable_18.2.x",
          "CHIBIOS_BOARD" : "ST_STM32F429I_DISCOVERY",
          "SWO_OUTPUT" : "ON",
          "NF_FEATURE_DEBUGGER" : "ON",
          "NF_FEATURE_RTC" : "ON",
          "API_Windows.Devices.Adc" : "ON",
          "API_Windows.Devices.Gpio" : "ON",
          "API_Windows.Devices.Spi" : "ON",
          "API_Windows.Devices.I2c" : "ON"
        }
      }
    }
  }
}
```

3. In the`.vscode` create a file named `settings.json` and paste the following

```json
{
    "cmake.generator": "Ninja",
    "cmake.configureSettings": {
        "CMAKE_MAKE_PROGRAM":"C:/nanoFramework_Tools/ninja/ninja.exe"
    },
    "cmake.cmakePath": "C:/nanoFramework_Tools/CMake/bin/cmake.exe"
}
```

4. Save all files and exit VS Code.

5. Reopen VS Code. It should load the workspace automatically. In the status bar at the bottom left, click on the `No Kit Selected` and select `[Unspecified]`.

6. In the status bar at the bottom left, click on the `CMake:MinSizeRel ST_STM32F429I_DISCOVERY: Ready` and select `MinSizeRel`. Wait for it to finish Configuring the project (progress bar shown in right bottom corner).

## Build nanoBooter and nanoCLR

1. In the status bar click `Build`.

2. Wait for the build to finish with `Build finished with exit code 0` output message.

3. In the `C:\nanoFramework\nf-interpreter\build` folder will be the required binary files:
- nanoBooter.bin
- nanoBooter.elf
- nanoBooter.hex
- nanoCLR.bin
- nanoCLR.elf
- nanoCLR.hex

## Flash the STM32 target

1. Download the [STM32 ST-LINK Utility](https://www.st.com/content/st_com/en/products/development-tools/software-development-tools/stm32-software-development-tools/stm32-programmers/stsw-link004.html) from ST web site and install it in your development machine.

2. Connect the Target board to your PC using an USB cable.

3. Open STM32 ST-Link Utility. And click on `Target > Connect`.

4. Next erase the entire chip by clicking on `Target > Erase Chip`.

5. Open `nanoBooter.hex` (`Open > Open File...`) and program and verify (`Target > Program & Verify...`). Make sure you tick the `Reset after programming` check box and hit `Start`. After the upload completes, the MCU is reset and the nanoBooter image runs. You can check the success of the operation watching for a slow blink pattern on the LED. Congratulations, you now have a board running nanoFramework's booter!

6. Open `nanoCLR.hex` (`Open > Open File...`) and program and verify (`Target > Program & Verify...`). Make sure you tick the `Reset after programming` check box and hit `Start`. After the upload completes, the MCU is reset and the nanoCLR image will run. This time and if all goes as expected, there will be no LED blinking.

## Next Steps

See [Getting Started](http://docs.nanoframework.net/articles/getting-started-guides/getting-started-managed.html) for instructions on creating and running a 'Hello World' managed application on your nanoFramework board.
