# Getting Started Guide for .NET **nanoFramework** VS Code extension

.NET **nanoFramework** enables the writing of managed code applications for embedded devices. Doesn't matter if you are a seasoned .NET developer or if you've just arrived here and want to give it a try.

The [VS Code](https://code.visualstudio.com/) extension allows you to use VS Code to flash, build and deploy your C# code for .NET **nanoFramework** on your device regardless of the platform you're using. This has been tested on Mac, Linux (64 bits) and Windows (64 bits).

![vs code gif](../../images/vs-code/nano-vs-code.gif)

## Features

This .NET nanoFramework VS Code extension allow you to flash, build and deploy your C# .NET nanoFramework application on an ESP32 or STM32 MCU.

### Flashing the device

Select `nanoFramework: Flash device` and follow the steps.

![nanoFramework: Flash device](../../images/vs-code/step-by-step6.png)

Based on the target you will select, the menus will automatically adjust to help you finding the correct version, DFU or Serial Port.

![select options](../../images/vs-code/step-by-step8.png)

Once all options has been selected, you'll see the flashing happening:

![flash happening](../../images/vs-code/step-by-step12.png)

### Building your code

Select `nanoFramework: Build Project` and follow the steps.

![select options](../../images/vs-code/step-by-step2.png)

If you have multiple solutions in the open folder, you'll be able to select the one to build:

![select options](../../images/vs-code/step-by-step3.png)

Build result will be display in the Terminal:

![select options](../../images/vs-code/step-by-step5.png)

### Deploy to your device

Select `nanoFramework: Deploy Project` and follow the steps.

![select options](../../images/vs-code/step-by-step14.png)

Similar as building the project, you'll have to select the project to deploy. The code will be built and the deployment will start:

![select options](../../images/vs-code/step-by-step17.png)

You'll get as well the status of the deployment happening in the Terminal.

Some ESP32 devices have issues with the initial discovery process and require an alternative deployment method.
If you're having issues with the deployment, you can use an _alternative_ method: you have to select `nanoFramework: Deploy Project (alternative method)` instead and follow the prompts, same as with the other steps.

## Requirements

You will need to make sure you'll have the following elements installed:

- [.NET 6.0](https://dotnet.microsoft.com/download/dotnet)
- [Visual Studio build tools](https://visualstudio.microsoft.com/en/thank-you-downloading-visual-studio/?sku=BuildTools&rel=16) on Windows, `mono-complete` on [Linux/macOS](https://www.mono-project.com/)

## Known Issues

This extension will **not** allow you to debug the device. Debug is only available on Windows with [Visual Studio](https://visualstudio.microsoft.com/downloads/) (any edition) and the [.NET nanoFramework Extension](https://marketplace.visualstudio.com/items?itemName=nanoframework.nanoFramework-VS2022-Extension) installed.

This extension will work on any Mac version (x64 or M1), works only on Linux x64 and Windows x64. Other 32 bits OS or ARM platforms are not supported.

## Install path issues

:warning: That are know issues running commands for STM32 devices when the user path contains diacritic characters. This causes issues with with STM32 Cube Programmer which is used by `nanoff` a dependency of the extension.
Note that if you're not using the extension with with STM32 devices, this limitation does not apply.
