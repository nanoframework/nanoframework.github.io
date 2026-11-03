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

### Using WSL2 and Dev Containers

You will need to follow this steps: 

1. Install Ubuntu-22.04 as a distro in WSL2 and set default:

```bash
wsl --install Ubuntu-22.04
wsl -s ubuntu-22.04
```

2. Access the Ubuntu-22.04 distro 

```bash
wsl
```

and then install kernel drivers

```bash
sudo apt-get update
sudo modprobe vhci_hcd
sudo apt install linux-tools-generic hwdata -y
sudo update-alternatives --install /usr/local/bin/usbip usbip /usr/lib/linux-tools/*-generic/usbip 20
sudo modprobe vhci_hcd
```

3. Go back to your windows, open powershell in Adminstrator mode, connect your board with USB and use usbipd to share the serial port. Keep the powershell session open.

```powershell
usbipd wsl list
usbipd unbind --busid 1-3
usbipd bind --busid 1-3
usbipd wsl attach --busid 1-3 --auto-attach
```

4. Open VSCode, create a new Dev Container
5. Edit the devcontainer.json file to include this run Argument to share the serial port from Ubuntu distri to your Dev Container env.

```json
    "runArgs": [
        "--device=/dev/ttyUSB0:/dev/ttyUSB0"
  	]
```

 6. In your new Dev Container, follow the process to install nanoFramework VSCode extension

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

