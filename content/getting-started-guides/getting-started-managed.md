# Getting Started Guide for managed code (C#)

**nanoFramework** enables the writing of managed code applications for embedded devices. Doesn't matter if you are a seasoned .NET developer or if you've just arrived here and want to give it a try.

This getting started guide will walk you through the setup of your development machine to get you coding a nice "Hello World" in no time!

You can find the video for this guide on our YouTube channel [here](https://youtu.be/iZdN2GmefXI).

## The hardware

In this guide we'll be using a ST Microelectronics [STM32F746 NUCLEO](http://www.st.com/content/st_com/en/products/evaluation-tools/product-evaluation-tools/mcu-eval-tools/stm32-mcu-eval-tools/stm32-mcu-nucleo/nucleo-f746zg.html) board. This is a rather common and inexpensive board that packs a Cortex M7 with 1MB flash, 320 kB of RAM and includes an ethernet connector.

## Installing Visual Studio

The first part is to get Visual Studio (both 2017 and 2019 versions are supported) and the **nanoFramework** extension installed.

1. Download Visual Studio. If you already have it installed, you can skip this step. If you don't, please download the free [Visual Studio Community](https://www.visualstudio.com/downloads) edition. Either way, make sure you've selected the .NET desktop workload.

1. **If using the latest preview (recommended), please make sure you are able to use the latest extension and NuGet's: https://nanoframework.net/2019/08/21/new-preview-feeds-for-nanoframework.**

1. Launch Visual Studio (we'll just refer to it as VS from now on) and install the **nanoFramework** extension. You can do this by going into Tools > Extensions and Updates. Make sure you've switched the left-hand tree view to the Online branch and enter _nanoFramework_ in the search box.

1. Now open the Device Explorer window. You can do this by going into View > Other Windows > Device Explorer.

## Uploading the firmware to the board using nanoFirmwareFlasher

The second part is to load the **nanoFramework** image in the board flash. The best way is to use the [nano Firmware Flasher](https://github.com/nanoframework/nanoFirmwareFlasher) tool. This is a .NET Core CLI command tool.

### Note: the VC++ 2010 x86 redistributable may required installing on your PC in certain circumstances.

1. Install [nano Firmware Flasher](https://github.com/nanoframework/nanoFirmwareFlasher).

    ```console
    dotnet tool install -g nanoFirmwareFlasher
    ```

1. Perform the update by providing the target name to nano Firmware Flasher. The official name of the target (either a reference or a community board) has to be used, otherwise it won't work as the tool isn't able to guess what board is connected.
(The following include the description for targets of several platforms for completeness)

    - To update the firmware of an ESP32 target connected to COM31, to the latest available development version.

        ```console
        nanoff --target ESP32_WROOM_32 --serialport COM31 --update
        ```

    - To update the firmware of a ST board connected through JTAG (ST-Link) to the latest available development version.

        ```console
        nanoff --target ST_NUCLEO144_F746ZG --update
        ```

    - To update the firmware of a ST board connected through DFU (like the NETDUINO3) you first need to put the board in DFU mode. This can be accomplished by pressing a certain combination of buttons. It depends on the particular hardware that you are using.

        ```console
        nanoff --target NETDUINO3_WIFI --update
        ```

1. After the upload completes, the MCU is reset and the nanoCLR image will run. You can check if the board is properly running **nanoFramework** by looking into the Device Explorer window in Visual Studio.

## Coding a 'Hello World' application

Now you have everything that you need to start coding your first application. Let's go for a good old 'Hello World' in micro-controller mode, which is blinking a LED, shall we?

1. Go back to VS and click File > New > Project. Make sure you have selected 'Framework 4.6 or above' and choose nanoFramework, on the left hand side tree view. Choose the 'Blank Application' template and a location of your choosing were the project files will be saved. Name your project and hit OK. The program file will be automatically opened for you.

1. We'll code a very simple application that enters an infinite loop and turns on and off an LED. We'll skip the details because that's not the aim of this guide. Let's just grab the code from the **nanoFramework** samples repo [here](https://github.com/nanoframework/Samples/tree/master/samples/Blinky). Make sure that the correct GPIO pin is being used. That's the line below the comment mentioning the STM32F746 NUCLEO board.

1. Because GPIO is being used we need to pull that class library and a reference to it in our project. The class libraries are distributed through NuGet. To add this class, right click on 'References' in the Solution Explorer and click 'Manage NuGet Packages'. On the search box type 'nanoFramework'. Make sure you have the preview checkbox ticked. Find the Windows.Devices.Gpio package and click "Install". After the license confirmation box, the package will be downloaded and a reference to it will be added. You'll notice that you no longer have the unknown references hints in VS.

1. Click "Build Solution" from the Build menu. A success message shows in the Build window.

1. We are almost there. Go into the Device Explorer window and click on the **nanoFramework** device showing there. Make sure the connection is OK by hitting the "Ping" button. On success, a message shows on the output window.

1. Let's deploy the application to the board. In order to do that, right click on the Project name and choose "Deploy". You'll see the feedback of the several operations that are running on the background in the Output Window. After a successful deployment you need to reset the target and your 'Hello World' blinky application will start running and, _voilá_, the LED starts blinking! If you want, instead of "just" deploying the application to the target you can choose to start a debug session. To do that hit F5 (as usual) in Visual Studio and watch it run.

## Wrapping up

Congratulations! That's your first **nanoFramework** C# application executing right there on the target board. How awesome is that?!

And this is it for the getting started guide.

You've went through the steps required to install Visual Studio, the **nanoFramework** extension and the ST-LINK Utility.

You've also learned how to upload **nanoFramework** firmware images into a target board.
And last, but not the least: how to code a simple 'Hello World' C# application and deploy it to a target board.

Check out other guides and tutorials. You may also want to join our [Discord channel](https://discordapp.com/invite/gCyBu8T), where you'll find a supportive community to discuss your ideas and help you in case you get stuck on something.
