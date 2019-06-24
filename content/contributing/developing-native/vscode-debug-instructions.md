# Instructions for debugging **nanoFramework** native code in VS Code

## Table of contents

- [Prerequisites](#prerequisites)
- [Preparation](#preparation)
- [Launch the debug session](#launch-the-debug-session)

**About this document**

This document describes how to debug **nanoFramework** native code using VS Code.

## Prerequisites

You'll need:

- [GNU ARM Embedded Toolchain](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads)
- [Visual Studio Code](http://code.visualstudio.com/)
- [C/C++ extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
- OpenOCD (any working distribution will work, follow some suggestions)
  - [Freddie Chopin OpenOCD (development)](http://www.freddiechopin.info/en/download/category/10-openocd-dev)
  - [OpenOCD – Open On-Chip Debugger](https://sourceforge.net/projects/openocd/)
  - [GNU ARM Eclipse OpenOCD](https://github.com/gnuarmeclipse/openocd)

## Preparation

You'll need a binary image with debug information to be loaded in the SoC or MCU.
Assuming you are using VS Code to launch your builds, you'll have this image ready to be loaded in the MCU.
(see [Build instructions documentation](build-instructions.md))

In order to launch the debug session you'll need to setup the *launch.json* file, located in the .vscode folder.
We've provided a template file [launch.TEMPLATE.json](..\.vscode\launch.TEMPLATE.json) to get you started with this. Just copy it and rename to *launch.json*.

Here's what you need to change in order to adapt the template file to your setup and make it more suitable to your working style and preferences.

- name: here you can name each of the launch configurations to help choosing the appropriate one when launching the debug session. These could be for example: "nanoBooter in Discovery 4", "nanoCLR in Nucleo F091RC", "test featureXYZ in Discovery 4".
- miDebuggerPath: full path to the gdb executable (this one is inside the GCC tool-chain folder)
- program: full path to the .elf output file that results from a successful build
- setupCommands (fourth 'text' entry): full path to the final image (the .hex file)
- setupCommands (fifth 'text' entry): the same as the program entry above (the .elf file)
- debugServerPath: full path to the OpenOCD executable
- debugServerArgs: full path to the scripts directory on the OpenOCD installation AND the appropriate .cfg files for the interface and the board.

_Note 1: VS Code parser seems to have trouble parsing and replacing the ${workspaceRoot} for some OpenOCD commands. That's the reason why you see there the ${workspaceRoot} variable and in other places the full path were that variable would make sense to be at. Just use what's there to keep OpenOCD happy._

_Note 2: Always mind the forward slash in the paths above, otherwise you'll get into troubles with strange and unclear errors from OpenOCD._

### Templates

To make your life easier, we provide templates with pre-configured launch.json for the various reference targets. Just grab them from our Gist.

- [ST_STM32F4_DISCOVERY](https://gist.github.com/nfbot/560137d32820c5cd3b06e77cb5d9bee7)

- [ST_STM32F429I_DISCOVERY](https://gist.github.com/nfbot/06eadeca52fbed933b4b37a5942661a6)

- [ST_NUCLEO_F091RC](https://gist.github.com/nfbot/827f96ab56d638d2a9806c59fd958112)

- [ST_NUCLEO144_F746ZG](https://gist.github.com/nfbot/11aa07dd11480a23810c58f33f82f499)

- [ST_STM32F769I_DISCOVERY](https://gist.github.com/nfbot/6629a3c37f4351ba793dd5e4e3228ca4)

- [TI_CC3220SF_LAUNCHXL](https://gist.github.com/nfbot/1c088f66b19fb20d45f0aa0656131239)

## Launch the debug session

Using VS Code menu View > Debug, clicking on the debug icon on the left hand toolbar or hitting the CTRL+SHIT+D shortcut you'll reach the debug view. There you'll find the launch configurations for debug that we've setup above (see the drop down at the top) and the familiar green play button (or F5 if you prefer).

When a debug session is active you can find a lot of familiar stuff:

- debug toolbar with the usual operations (pause, step over, into, out, restart and stop)
- variables list
- call stack that you can use to navigate up and down
- breakpoint list to manage those
- watch expressions
- support for 'mouse over' a variable which will display a context with the variable content
- ability to set/remove breakpoints by clicking near the line number
- other handy tools and options using the right click on the various objects
