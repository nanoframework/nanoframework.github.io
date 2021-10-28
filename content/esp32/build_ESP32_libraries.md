# Build the ESP32 IDF Libraries

With the latest IDF v3.3.5 we are now building 3 different versions of the libraries. This is due to the IRAM memory section overflowing when BLE is added.

The main reason for this is due to the PSRAM fixes that are used with the ESP32 Version 1 chips. ESP32 Version 0 doesn't support PSRAM and Version 3 chips have the PSRAM problems fixed.

Library variants

- Default - This is the default version of and supports everything except Bluetooth.
- BLE - This includes support for Bluetooth but due to memory constraints removes PSRAM support.
- V3 - Includes all support, PSRAM and BLE but only useable on ESP32 version 3 chips.

## Initial Setup

- Using the instructions on the Espressif [website](https://esp-idf.readthedocs.io/en/latest/get-started/windows-setup.html).

- Download the complete Msys2 environment and toolchain and unzip to c:\msys2

- Download the required [ESP IDF](https://dl.espressif.com/dl/esp-idf/releases/esp-idf-v3.3.5.zip) into the nanoClr build default location c:\Esp32_tools\esp-idf-v3.3.5

- Set up your Windows environment with the IDF_PATH=c:\Esp32_tools\esp-idf-v3.3.5

## Setup projects for each library

Create 3 directories, one for each library variant, wherever you like, called:-

- Wroom32
- Wroom32BLE
- Wroom32V3

If you only need 1 library for your project then just create the needed one.

Into each of the project directories copy the the blink project from the IDF:-
c:\Esp32_tools\esp-idf-v3.3.5\example\get-started/blink/

Now copy the *SDKCONFIG* & *Copylibs.cmd* from the latest nf-interpreter repo.
There is a different version for each of the different library variants under target/targets\FreeRTOS_ESP32\ESP32_WROOM_32\IDF\Libraries.

As we are not able to configure all the FatFs parameters in the SDKCONFIG we need to update IDF version.

Copy file *ffconf.h* from target/targets\FreeRTOS_ESP32\ESP32_WROOM_32\IDF\Libraries to C:\ESP32_TOOLS\esp-idf-v3.3.5\components\fatfs\src

## Building Libraries

Start Msys command shell C:\msys32\mingw32.exe

From the command shell change to each of the projects directories you created and make the project.
For example if project is under IDF examples dir then:-

cd /c/esp32_tools/esp-idf-v3.3.5/examples/Wroom32
make

Exit msys2

## Copy libraries

Under a normal windows command prompt change to each of the project directories and run the CopyLibs command.
These will create the library directories c:\esp32_tools \ for each of the projects

- libs-v3.3.5
- libs-v3.3.5_BLE
- libs-v3.3.5_V3

These names are in the format that the build system expects so don't rename them.

## Check/update build files

In the nf-interpreter repo check/update the following files if IDF versions have changed:

- azure-pipelines-templates\build-esp32.yml
- azure-pipelines-templates\download-install-esp32-build-components.yml
- install-scripts\install-esp32-idf.ps1
- install-scripts\install_esp32-libs.ps1
