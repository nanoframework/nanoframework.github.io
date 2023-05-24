# Class Libraries

## About this document

This document describes the design and organization of .NET **nanoFramework** Class Libraries, offers some explanation on the choices that were made and how to add a new Class Library. The examples bellow are related with ChibiOS (which is the currently reference implementation for .NET **nanoFramework**).

## Libraries

Follow the list of the existing libraries, respective NuGet package and CMake enable option:

| Class Library | Version | CMake option |
| --- | --- | --- |
| Base Class Library (also know as mscorlib) |[![NuGet](https://img.shields.io/nuget/v/nanoFramework.CoreLibrary.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.CoreLibrary/) | (always included) |
| Base Class Library (without Reflection) |  [![NuGet](https://img.shields.io/nuget/v/nanoFramework.CoreLibrary.NoReflection.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.CoreLibrary.NoReflection/) | (always included, -DNF_FEATURE_SUPPORT_REFLECTION=OFF) |
| nanoFramework.Device.Bluetooth | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Device.Bluetooth.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Device.Bluetooth/) | -DAPI_nanoFramework.Device.Bluetooth=ON |
| nanoFramework.Device.Can | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Device.Can.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Device.Can/) | -DAPI_nanoFramework.Device.Can=ON |
| nanoFramework.Device.OneWire |  [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Device.OneWire.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Device.OneWire/) | -DAPI_nanoFramework.Device.OneWire=ON |
| nanoFramework.Graphics |  [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Graphics.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Graphics/) | -DAPI_nanoFramework.Graphics=ON |
| nanoFramework.GiantGecko.Adc | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.GiantGecko.Adc.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.GiantGecko.Adc/) | -DAPI_nanoFramework.GiantGecko.Adc=ON |
| nanoFramework.M5Stack | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.M5Stack.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.M5Stack/) | -DAPI_nanoFramework.M5Stack=ON |
| nanoFramework.Hardware.Esp32 | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Hardware.Esp32.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Hardware.Esp32/) | -DAPI_Hardware.Esp32=ON |
| nanoFramework.Hardware.Esp32.Rmt | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Hardware.Esp32.Rmt.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Hardware.Esp32.Rmt/) | -DAPI_Hardware.Esp32.Rmt=ON |
| nanoFramework.Hardware.GiantGecko  | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Hardware.GiantGecko.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Hardware.GiantGecko/) | -DAPI_Hardware.GiantGecko=ON |
| nanoFramework.Hardware.Stm32 | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Hardware.Stm32.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Hardware.Stm32/) | -DAPI_Hardware.Stm32=ON |
| nanoFramework.Hardware.TI | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Hardware.TI.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Hardware.TI/) | -DAPI_Hardware.TI=ON |
| nanoFramework.ResourceManager | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.ResourceManager.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.ResourceManager/) | -DAPI_nanoFramework.ResourceManager=ON |
| nanoFramework.Runtime.Events | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Runtime.Events.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Runtime.Events/) | (always included) |
| nanoFramework.Runtime.Native | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Runtime.Native.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Runtime.Native/) | (always included) |
| nanoFramework.Networking.Sntp | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Networking.Sntp.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Networking.Sntp/) | (included when network option is ON) |
| nanoFramework.TI.EasyLink | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.TI.EasyLink.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.TI.EasyLink/) | -DAPI_nanoFramework.TI.EasyLink=ON |
| System.Device.Adc | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Device.Adc.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Device.Adc/) | -DAPI_System.Device.Adc=ON |
| System.Device.Dac | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Device.Dac.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Device.Dac/) | -DAPI_System.Device.Dac=ON |
| System.Device.I2c | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Device.I2c.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Device.I2c/) | -DAPI_System.Device.I2c=ON |
| System.Device.I2s | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Device.I2s.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Device.I2s/) | -DAPI_System.Device.I2s=ON |
| System.Device.Gpio | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Device.Gpio.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Device.Gpio/) | -DAPI_System.Device.Gpio=ON |
| System.IO.FileSystem | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.IO.FileSystem.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.IO.FileSystem/) | -DAPI_System.IO.FileSystem=ON |
| System.IO.Ports | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.IO.Ports.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.IO.Ports/) | -DAPI_System.IO.Ports=ON |
| System.IO.Streams | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.IO.Streams.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.IO.Streams/) | -DAPI_System.IO.Streams=ON |
| System.Device.Pwm | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Device.Pwm.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Device.Pwm/) | -DAPI_System.Device.Pwm=ON |
| System.Device.Spi | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Device.Spi.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Device.Spi/) | -DAPI_System.Device.Spi=ON |
| System.Device.WiFi | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Device.WiFi.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Device.WiFi/) | -DAPI_System.Device.WiFi=ON |
| System.Device.UsbStream | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Device.UsbClient.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Device.UsbClient/) | -DAPI_System.Device.UsbStream=ON |
| Windows.Storage | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Windows.Storage.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Windows.Storage/) | -DNF_FEATURE_HAS_SDCARD=ON and/or -DNF_FEATURE_HAS_USB_MSD=ON |
| Windows.Storage.Streams | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Windows.Storage.Streams.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Windows.Storage.Streams/) | -DAPI_=ON |
| System.IO.FileSystem | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.IO.FileSystem.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.IO.FileSystem/) | -DAPI_System.IO.FileSystem=ON |
| System.Collections | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Collections.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Collections/) | no native code |
| System.Math | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Math.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Math/) | -DAPI_System.Math=ON |
| System.Net | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Net.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Net/) | -DAPI_System.Net=ON |
| System.Net.Http | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Net.Http.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Net.Http/) | no native code |
| System.Net.Http.Client | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Net.Http.Client.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Net.Http.Client/) | no native code |
| System.Net.Http.Server | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Net.Http.Server.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Net.Http.Server/) | no native code |
| System.Net.Sockets.UdpClient | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Net.Sockets.UdpClient.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Net.Sockets.UdpClient/) | no native code |
| System.Net.Sockets.TcpClient | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Net.Sockets.TcpClient.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Net.Sockets.TcpClient/) | no native code |
| System.Runtime.Serialization | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Runtime.Serialization.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Runtime.Serialization/) | no native code |
| System.Text | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Text.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Text/) | no native code |
| System.Text.RegularExpressions | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Text.RegularExpressions.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Text.RegularExpressions/) | no native code |
| System.Threading | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.System.Threading.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.System.Threading/) | no native code |

## Other libraries

| Class Library | Version |
| --- | --- |
| AMQP Net Lite | [![NuGet](https://img.shields.io/nuget/v/AMQPNetLite.nanoFramework.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/AMQPNetLite.nanoFramework/) |
|AMQP Net Lite (micro) | [![NuGet](https://img.shields.io/nuget/v/AMQPNetMicro.nanoFramework.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/AMQPNetMicro.nanoFramework/) |
| nanoFramework.Azure.Devices | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Azure.Devices.Client.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Azure.Devices.Client/) |
| nanoFramework.Aws.IoTCore.Devices | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Aws.IoTCore.Devices.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Aws.IoTCore.Devices/) |
| nanoFramework.Logging | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Logging.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Logging/) |
| nanoFramework.Json | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Json.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Json/) |
| nanoFramework.m2mqtt | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.m2mqtt.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.m2mqtt/) |
| nanoFramework.SignalR.Client | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.SignalR.Client.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.SignalR.Client/) |
| nanoFramework.TestFramework | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.TestFramework.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.TestFramework/) |
| nanoFramework.WebServer | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.WebServer.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.WebServer/) |
| nanoFramework.DependencyInjection | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.DependencyInjection.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.DependencyInjection/) |
| nanoFramework.Hosting | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Hosting.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Hosting/) |

## Board Support Packages libraries

| Class Library | Version |
| --- | --- |
| nanoFramework.M5Stack | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.M5Stack.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.M5Stack/) |
| nanoFramework.M5Stick | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.M5StickC.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.M5StickC/) |
| nanoFramework.M5StickCPlus | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.M5StickCPlus.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.M5StickCPlus/) |
| nanoFramework.M5Core2 | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.M5Core2.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.M5Core2/) |
| nanoFramework.AtomLite | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.AtomLite.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.AtomLite/) |
| nanoFramework.AtomMatrix | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.AtomMatrix.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.AtomMatrix/) |
| nanoFramework.Fire | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.Fire.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.Fire/) |
| nanoFramework.MagicBit | [![NuGet](https://img.shields.io/nuget/v/nanoFramework.MagicBit.svg?label=NuGet&style=flat&logo=nuget)](https://www.nuget.org/packages/nanoFramework.MagicBit/) |

## Distribution strategy

To ease the burden of distributing and updating the class libraries we've choose to use Nuget to handle all this. It has the added benefit of dealing with the dependency management, version and such.

So, for each class library, there is a Nuget package that includes the assembly and documentation files. The Nuget package takes care of making sure that the required dependency(ies) and correct version(s) are added to a managed (C#) project, making a developer's life much easier.

## How to add a new class library

Follow the procedure to add a new class library to a .NET **nanoFramework** target image.

The example is for adding System.Device.Gpio library.

1. In Visual Studio start a new project for a .NET **nanoFramework** C# Class library. Source code [here](https://github.com/nanoframework/System.Device.Gpio)

1. Implement all the required methods, enums, properties in that project. It's recommended that you add XML comments there (and enable the automated documentation generation in the project properties).

1. Add the NuGet packaging project to distribute the managed assembly and documentation. We have a second NuGet package that includes all the build artefacts, generated stubs, dump files and such. This is to be used in automated testing and distribution of follow-up projects or build steps.

1. Upon a successfully build of the managed project the skeleton with the stubs should be available in the respective folder. Because .NET **nanoFramework** aims to be target independent, the native implementation of a class library can be split in two parts:
   - Declaration and common code bits (these always exist) inside the `src` folder. This is the place where the stubs must be placed:
      - Common [System.Device.Gpio](https://github.com/nanoframework/nf-interpreter/tree/main/src/System.Device.Gpio).
   - The specific implementation bits that are platform dependent and that will live 'inside' each platform RTOS folder:
      - ChibiOS [System.Device.Gpio](https://github.com/nanoframework/nf-interpreter/tree/main/targets/ChibiOS/_nanoCLR/System.Device.Gpio).
      - ESP32 FreeRTOS [System.Device.Gpio](https://github.com/nanoframework/nf-interpreter/tree/main/targets/ESP32/_nanoCLR/System.Device.Gpio).
      - TI-RTOS [System.Device.Gpio](https://github.com/nanoframework/nf-interpreter/tree/main/targets/TI_SimpleLink/_nanoCLR/System.Device.Gpio).

1. Add the CMake as a module to the modules folder [here](https://github.com/nanoframework/nf-interpreter/tree/develop/CMake/Modules). The name of the module should follow the assembly name (Find**System.Device.Gpio**.cmake). Mind the CMake rules for the naming: start with _Find_ followed by the module name and _cmake_ extension. The CMake for the System.Device.Gpio module is [here](https://github.com/nanoframework/nf-interpreter/blob/main/CMake/Modules/FindSystem.Device.Gpio.cmake).

1. In the CMake [FindNF_NativeAssemblies.cmake](https://github.com/nanoframework/nf-interpreter/blob/main/CMake/Modules/FindNF_NativeAssemblies.cmake) add an option for the API. The option name must follow the pattern API_**namespace**. The option for System.Device.Gpio is API_System.Device.Gpio.

1. In the CMake [NF_NativeAssemblies.cmake](https://github.com/nanoframework/nf-interpreter/blob/main/CMake/Modules/FindNF_NativeAssemblies.cmake) find the text `WHEN ADDING A NEW API add the corresponding block below` and add a block for the API. Just copy/paste an existing one and replace the namespace with the one that you are adding.

1. Update the CMake presets file (or files, if this is to be added to multiple targets) e.g. for the ST_STM32F769I_DISCOVERY [here](https://github.com/nanoframework/nf-interpreter/blob/main/targets/ChibiOS/ST_STM32F769I_DISCOVERY/CMakePresets.json) to include the respective option. For the System.Device.Gpio example you would add in the _cacheVariables_ collection the following entry: "API_System.Device.Gpio" : "ON".

1. If the API requires enabling hardware or SoC peripherals in the target HAL/PAL make the required changes to the appropriate files.
For System.Device.Gpio in ChibiOS there is nothing to enable because the GPIO subsystem is always enabled.
In contrast, for the System.Device.Spi, the SPI subsystem has to be enabled at the _halconf.h_ file and also (at driver level) in _mcuconf.h_ the SPI peripherals have to be individually enabled (e.g. `#define STM32_SPI_USE_SPI1 TRUE`).

    > Note: To ease the overall configuration of an API and related hardware (and when it makes sense) the API option (API_System.Device.Gpio) can be _extended_ to automatically enable the HAL subsystem. This happens with the System.Device.Spi API. The CMake option is mirrored in the general [CMakeLists.txt](https://github.com/nanoframework/nf-interpreter/blob/main/CMakeLists.txt) in order to be used in CMakes and headers. This mirror property is `HAL_USE_SPI_OPTION`. It's being defined here and not in the individual _halconf.h_ files as usual. To make this work the CMake property has to be added to the CMake template file of the platform [target_platform.h.in](https://github.com/nanoframework/nf-interpreter/blob/main/targets/ChibiOS/_nanoCLR/target_platform.h.in).

1. When adding/enabling new APIs and depending on how the drivers and the library are coded, some static variables will be added to the BSS RAM area. Because of that extra space that is taken by those variables the Managed Heap size may have to be adjusted to make room for those. To do this find the `__clr_managed_heap_size__` in the general CMakeLists.txt of that target and decrease the value there as required.

1. Some APIs depend of others. This happens for example with System.Device.Gpio that requires nanoFramework.Runtime.Events in order to generate the interrupts for the changed pin values. To make this happen the option to include the required API(s) has to be enabled in the main [CMakeLists.txt](https://github.com/nanoframework/nf-interpreter/blob/main/CMakeLists.txt) inside the if clause of the dependent API. Just like if the option was enabled at the CMake command line. Check this by searching for `API_nanoFramework.Runtime.Events` inside the `if(API_System.Device.Gpio)`.

## How to include a class library in the build

To include a class library in the build for a target image you have to add to the CMake an option for the API. For the System.Device.Gpio example the option would be `-DAPI_System.Device.Gpio=ON`.
You can also add this to your own `CMakePresets.json` / `CMakeUserPresets.json` file.
To exclude a class library just set the option to OFF or simply don't include it in the command.
