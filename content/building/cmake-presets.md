# CMake Presets

## About this document

This document describes how to use and modify the CMake presets to suit your needs.

**CMakePresets.json** and **CMakeUserPresets.TEMPLATE.json** files to suit your needs.

## Introduction

Our build system uses [CMake](https://cmake.org/) and [CMake presets](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html) to configure the various build options.
The build can be managed and configured using a command prompt or directly from [VS Code](https://github.com/microsoft/vscode-cmake-tools/blob/main/docs/cmake-presets.md) or [Visual Studio](https://learn.microsoft.com/en-us/cpp/build/cmake-presets-vs?view=msvc-160).

The simplest way to tweak a build or configuration preset is to create a `CMakeUserPresets.json` and override in this file, any of the configurations and options set in the presets. You can read more details on how the user presets work on the document above about CMake presets.

Follows an example to illustrate how this works. Let's imagine that a developer working on a ESP32 WROVER KIT doesn't need support for the display and is not interest in support for SD Card either.
Both options are being set in the target preset, so it's a simple matter of overriding them like this:

```json
{
    "version": 4,
    "configurePresets": [
        {
            "name": "MY_ESP_WROVER_KIT",
            "hidden": true,
            "inherits": [
                "ESP_WROVER_KIT"
            ],           
            "cacheVariables": {
                "NF_FEATURE_HAS_SDCARD": "OFF",
                "API_nanoFramework.Graphics": "OFF"
            }
        },      
    ],
    "buildPresets": [
        {
            "name": "MY_ESP_WROVER_KIT",
            "displayName": "MY_ESP_WROVER_KIT",
            "configurePreset": "MY_ESP_WROVER_KIT"
        }
    ] 
}
```

With the above, a new configure preset named `MY_ESP_WROVER_KIT` was created inheriting the original preset `ESP_WROVER_KIT` and overriding the build options that one is interested in changing. Following this a new build preset is also created to expose the configure preset.
With the above a new configure preset `MY_ESP_WROVER_KIT` is made available and ready to be used in CMake CLI, VS Code or Visual Studio.

Other adjustments, with potentially broader impact, can be made in the `config\user-prefs.json` and `config\user-tools-repos.json` preset files.

## Build options for CMake Presets

Below is a list of the build options available (last updated October 2022). These can be found at the various CMake presets files available.
***Note:*** some of these options are specific to the `RTOS` or target type.

- "BUILD_VERSION" : "**version-number-for-the-build-format-is-N.N.N.N**"
  - This can be used [to prevent a board from updating if working on a custom firmware](../faq/automatic-firmware-updates.md#l13)
  - This can be used to workaround "[Found assemblies mismatches when checking for deployment pre-check](build-instructions.md#preparation)" error during deployment.
- "BUILD_VERBOSE"
  - Option to output verbose messages during build. Useful for debugging issues with build system.
- "TOOL_HEX2DFU_PREFIX" : "**absolute-path-to-hex2dfu-utility-mind-the-forward-slash**"
  - This is the path to the HEX2DFU utility. Use forward slashes and do not provide executable name here.
- "TARGET_BOARD"
  - Valid target name from platform boards collection.
- "ESP32_IDF_PATH" : "**absolute-path-to-esp-idf-mind-the-forward-slash**"
  - This the path to the ESP32 IDF utility. Use forward slashes and do not provide executable name here.
- "EXECUTABLE_OUTPUT_PATH" : "**${workspaceRoot}/build**"
  - This is the default and recommended path which will expand to the build folder when building from VS Code. When building from the command line or from Visual Studio this is not required.
- "TARGET_SERIES" : "**STM32F7xx**"
  - For STM32 MCUs represents the target series (STM32F4XX, STM32L4XX, and so on)
  - For ESP32 represents the target series (ESP32, ESP32_S2, and so on)
  - For NXP represents the target series (IMXRT10xx)
  - For TI SimpleLink targets represents the target series (CC13X2, CC32xx)
- "TARGET_SERIAL_BAUDRATE"
  - Baudrate for serial communication. Only required to override default.
- "TARGET_NAME"
  - Required only if need to override the target name on the firmware.
- "USE_RNG" : **`ON`**
  - Option to enable the use of the hardware true random generator unit, if present. Default is ON as the majority of the targets have this feature.
- "DP_FLOATINGPOINT" : **`OFF`**
  - Enables support for double-precision floating point. The default is single-precision. Set to ON to enable double precision floating point.
- "SUPPORT_ANY_BASE_CONVERSION" : **`OFF`**
  - Defines which bases are supported when performing string to value conversions. When ON support for any base is enabled. When `OFF` (the default) the image will be compiled with support for base 10 and base 16 only.
- "RTOS" : "**one-of-valid-rtos-options**"
  - Defines the RTOS that will be used to build nanoFramework. Valid options: ChibiOS, ESP32, AzureRTOS and FreeRTOS.
- "CHIBIOS_SOURCE_FOLDER" : ""
  - Path to an optional local installation of ChibiOS source files. If no path is given, then CMake will download the sources automatically from ChibiOS SVN repository when required. Mind the forward slash.
- "CHIBIOS_HAL_REQUIRED" : **`OFF`**
  - Set to ON to include ChibiOS HAL repository in the build.
- "CHIBIOS_HAL_SOURCE": ""
  - Path to an optional local installation of ChibiOS source files. If no path is given, then CMake will download the sources automatically from ChibiOS SVN repository when required. Mind the forward slash.
- "CHIBIOS_HAL_VERSION": ""
  - Valid ChibiOS version. If empty use default CMake setting.
- "CHIBIOS_CONTRIB_REQUIRED": **`OFF`**
  - Set to ON to include ChibiOS Contrib repository in the build.
- "CHIBIOS_CONTRIB_SOURCE": ""
  - Path to an optional local installation of ChibiOS Contrib source files. If no path is given, then CMake will download the sources automatically from ChibiOS Contrib repository when required. Mind the forward slash.
- "FREERTOS_SOURCE_FOLDER": ""
  - Path to an optional local installation of FreeRTOS source files. If no path is given, then CMake will download the sources automatically from FreeRTOS repository when required. Mind the forward slash.
- "CMSIS_SOURCE": ""
  - Path to an optional local installation of CMSIS source files. If no path is given, then CMake will download the sources automatically from CMSIS repository when required. Mind the forward slash.
- "CMSIS_VERSION": ""
  - Valid CMSIS version. If empty use default CMake setting.
- "STM32_CUBE_PACKAGE_REQUIRED": **`OFF`**
  - Set to ON to include STM Cube package in the build.
- "STM32_HAL_DRIVER_SOURCE": ""
  - Path to an optional local installation of CMSIS source files. If no path is given, then CMake will download the sources automatically from CMSIS repository when required. Mind the forward slash.
- "STM32_CMSIS_DEVICE_SOURCE": ""
  - Path to an optional local installation of CMSIS device source files. If no path is given, then CMake will download the sources automatically from CMSIS device repository when required. Mind the forward slash.
- "STM32_CMSIS_CORE_SOURCE": ""
  - Path to an optional local installation of SMT32 CMSIS source files. If no path is given, then CMake will download the sources automatically from SMT32 CMSIS repository when required. Mind the forward slash.
- "TI_SL_CC32xx_SDK_SOURCE": ""
  - Path to an optional local installation of SMT32 CMSIS source files. If no path is given, then CMake will download the sources automatically from SMT32 CMSIS repository when required. Mind the forward slash.
<path-to-local-TI_SimpleLink-CC32xx-SDK-source-mind-the-forward-slash>",
- "TI_SL_CC13xx_26xx_SDK_SOURCE": ""
  - Path to an optional local installation of TI SimpleLink CC13xx_26xx SDK source files. If no path is given, then CMake will download the sources automatically from TI SimpleLink CC13xx_26xx SDK repository when required. Mind the forward slash.
- "TI_XDCTOOLS_SOURCE": ""
  - Path to an optional local installation of TI XDC Tools source files. If no path is given, then CMake will download the sources automatically from TI XDC Tools repository when required. Mind the forward slash.
- "TI_SYSCONFIG_SOURCE": ""
  - Path to an optional local installation of TI SysConfig source files. If no path is given, then CMake will download the sources automatically from TI SysConfig repository when required. Mind the forward slash.
- "RADIO_FREQUENCY": "915",
  - Valid frequency for CC13xx_26xx targets. Possible values are 868 and 915.
- "SPIFFS_SOURCE": ""
  - Path to an optional local installation of Spiffs source files. If no path is given, then CMake will download the sources automatically from Spiffs repository when required. Mind the forward slash.
- "FATFS_SOURCE": ""
  - Path to an optional local installation of FatFS source files. If no path is given, then CMake will download the sources automatically from FatFS repository when required. Mind the forward slash.
- "FATFS_VERSION": ""
  - Valid FatFS version. If empty use default CMake setting.
- "LWIP_VERSION": ""
  - Valid lwIP version. If empty use default CMake setting.
- "ESP32_XTAL_FREQ_26": **`OFF`**
  - Set to ON to enable XTAL frequency to 26M.
- "ESP32_USB_CDC": **`OFF`**
  - Set to ON to enable embedded USB CDC. Valid for ESP32_S2 series.
- "ESP32_ETHERNET_SUPPORT": **`OFF`**
  - Set to ON to enable Ethernet support for ESP32 target.
- "SDK_CONFIG_FILE": ""
  - Path to an optional location of IDF SDK config file. If no path is given, then CMake will build one according to the target and relevant build options.
- "SWO_OUTPUT" : **`OFF`**
  - Allows specifying whether to include, or not, support for Cortex-M Single Wire Output (SWO). Default is `OFF`. Check the documentation [here](../contributing/developing-native/arm-swo.md) for more details on how to use SWO.
- "NF_BUILD_RTM" : **`OFF`**
  - Sets the build to be **R**elease **T**o **M**anufacturing type. Meaning that all debugger features, instrumentation and debug helper code will be removed from compilation. The build will be compiled and linked with all possible code reducing options enabled. An RTM build doesn't have debugging capabilities, meaning that a debug session can not be started. In order to deploy to a device running an RTM build `nanoff` CLI should be used or any other mean that can flash the deployment region.
- "NF_TRACE_TO_STDIO": **`OFF`**
  - Set to ON to enable trace messages to stdio.
- "NF_WP_TRACE_ERRORS" : **`OFF`**
  - Enable error tracing in Wire Protocol.
- "NF_WP_TRACE_HEADERS" :  **`OFF`**
  - Enable packet headers tracing in Wire Protocol.
- "NF_WP_TRACE_STATE" :  **`OFF`**
  - Enable state tracing in Wire Protocol.
- "NF_WP_TRACE_NODATA" :  **`OFF`**
  - Enable tracing of empty or incomplete packets in Wire Protocol.
- "NF_WP_TRACE_ALL" :  **`OFF`**
  - Enable all tracing options for Wire Protocol.
- "NF_WP_IMPLEMENTS_CRC32" :  **`ON`**
  - Enable CRC32 calculations for Wire Protocol. See details [here](../architecture/wire-protocol.md#crc32-validations).
- "NF_FEATURE_DEBUGGER" : **`OFF`**
  - Defines is support for debuggin managed applications is enabled. Default is `OFF`.
- "NF_FEATURE_RTC" : **`OFF`**
  - Allows you to specify whether to use the real time clock unit of the hardware for date & time functions. Depends on target availability. Default is `OFF`.
- "NF_FEATURE_USE_APPDOMAINS" : **`OFF`**
  - Allows you to specify whether to include, or not, support for Application Domains. Default is `OFF`. More information about this is available in the documentation [here](https://msdn.microsoft.com/en-us/library/cxk374d9(v=vs.90).aspx). **Note that the complete removal of support for this feature is being considered.**
- "NF_FEATURE_SUPPORT_REFLECTION": "ON"
  - Set to `OFF` to disable support for System.Reflection API.
- "NF_FEATURE_BINARY_SERIALIZATION": **`ON`**
  - Set to `OFF` to disable support for binary serialization/deserialization. This is only applicable with NF_FEATURE_SUPPORT_REFLECTION set to `ON`.
- "NF_FEATURE_WATCHDOG" : **`ON`**
  - Allows you to define it the hardware watchdog should be disabled.
   This setting can only be set to `OFF` for STM32 targets. ESP32 build enables this by default so there is no way to disable it.
   Default is ON, so the hardware watchdog will be enabled by default.
- "NF_FEATURE_HAS_CONFIG_BLOCK" : **`OFF`**
  - Allows the developer to set if the targets platform has configuration block.
  This requires the the block storage definition and the linker files add support for that.
  Default is `OFF` meaning that that the target DOES NOT have configuration block.
- "NF_PLATFORM_NO_CLR_TRACE" : **`OFF`**
  - Allows you to define if trace messages and checks are added to CLR or not.
  These checks are usually valuable when debugging issues within the CLR.
  Can and should be removed for RTM build flavours.
  Default is `OFF` meaning that all the standard trace and checks are added to the CLR.
- "NF_CLR_NO_IL_INLINE" : **`OFF`**
  - Allows you to define if CLR will use IL inlining.
  Default is `OFF` meaning that CLR will inline IL.
- "NF_INTEROP_ASSEMBLIES" : "Assembly1-Namespace Assembly2-Namespace Assembly3-Namespace"
  - Lists the name of the Interop assembly(ies) to be added to the build in a space separated string. Leave empty or don't add it if no Interop assembly is to be added.
- "NF_NETWORKING_SNTP" : **`ON`**
  - Allows you to specify whether SNTP is enabled. Requires networking feature to be enabled. Default is ON.
- "NF_SECURITY_MBEDTLS" : **`OFF`**
  - Enables support for secure sockets using mbedTLS. Default is `OFF`.
- "MBEDTLS_SOURCE" : **`OFF`**
  - Path to an optional local with mbedTLS source files.
- "API_nanoFramework.Device.OneWire" : **`OFF`**
  - Allows you to specify whether support for OneWire functions are available to your application. Default is `OFF`.
- "API_System.Device.Dac" : **`OFF`**
  - Allows you to specify whether DAC functions are available to your application. Default is `OFF`.
- "API_System.Math" : **`OFF`**
  - Allows you to specify whether System.Math support is available to your application. Default is `OFF`.
- "API_System.Net" : **`OFF`**
  - Allows you to specify whether System.Net support is available to your application. Default is `OFF`.
- "API_nanoFramework.Device.Can" : **`OFF`**
  - Allows you to specify whether CAN bus functions are available to your application. Default is `OFF`.
- "API_System.Device.Adc" : **`OFF`**
  - Allows you to specify whether ADC functions are available to your application. Default is `OFF`.
- "API_System.Device.Gpio" : **`OFF`**
  - Allows you to specify whether GPIO functions are available to your application. Default is `OFF`.
- "API_System.Device.I2c" : **`OFF`**
  - Allows you to specify whether I2C functions are available to your application. Default is `OFF`.
- "API_System.Device.Pwm" : **`OFF`**
  - Allows you to specify whether PWM functions are available to your application. Default is `OFF`.
- "API_System.IO.Ports" : **`OFF`**
  - Allows you to specify whether Serial Communication functions are available to your application. Default is `OFF`.
- "API_System.Device.Spi" : **`OFF`**
  - Allows you to specify whether SPI functions are available to your application. Default is `OFF`.
- "API_Windows.Networking.Sockets" : **`OFF`**
  - Allows you to specify whether Networking Sockets functions are available to your application. Default is `OFF`.
- "API_Windows.Storage" : **`OFF`**
  - Allows you to specify whether Windows.Storage functions are available to your application. Default is `OFF`.
- "API_Hardware.Esp32" : **`OFF`**
  - Allows you to specify whether Hardware.Esp32 functions are available to your application. Default is `OFF`.
  Note that this API is exclusive of ESP32 targets and can't be used with any other.
- "API_Hardware.Stm32" : **`OFF`**
  - Allows you to specify whether Hardware.Stm32 functions are available to your application. Default is `OFF`.
  Note that this API is exclusive of STM32 targets and can't be used with any other.
- "API_nanoFramework.ResourceManager" : **`OFF`**
- "API_nanoFramework.TI.EasyLink" : **`OFF`**
  - Allows you to specify whether TI.EasyLink functions are available to your application. Default is `OFF`.
  Note that this API is exclusive for TI targets and can't be used with any other.
- "API_nanoFramework.Hardware.TI" : **`OFF`**
  - Allows you to specify whether Hardware.TI functions are available to your application. Default is `OFF`.
    Note that this API is exclusive for TI targets and can't be used with any other.
- "API_nanoFramework.System.Collections" : **`OFF`**
  - Allows you to specify whether System.Collections functions are available to your application. Default is `OFF`.
- "API_nanoFramework.System.Text" : **`OFF`**
  - Allows you to specify whether System.Text functions are available to your application. Default is `OFF`.
- "API_System.Device.Wifi" : **`OFF`**
  - Allows you to specify whether Device.Wifi functions are available to your application. Default is `OFF`.
  Note that this API is exclusive of ESP32 targets and can't be used with any other.
- "API_nanoFramework.Device.Bluetooth" : **`OFF`**
  - Allows you to specify whether Device.Bluetooth functions are available to your application. Default is `OFF`.
  Note that this API is exclusive of ESP32 targets and can't be used with any other.
- "API_System.IO.FileSystem" : **`OFF`**
  - Allows you to specify whether System.IO.FileSystem functions are available to your application. Default is `OFF`.
- "API_nanoFramework.Graphics" : **`OFF`**
  - Allows you to specify whether Graphics functions are available to your application. Default is `OFF`.
  Note that this API has the following sub options required depending on target:
    - "GRAPHICS_MEMORY"
    - "GRAPHICS_DISPLAY"
    - "GRAPHICS_DISPLAY_INTERFACE"
    - "TOUCHPANEL_DEVICE"
    - "TOUCHPANEL_INTERFACE"
- "NF_FEATURE_HAS_SDCARD" : **`OFF`**
  - Set to ON to enable support for SDCard storage device.
- "NF_FEATURE_HAS_USB_MSD" : **`OFF`**
  - Set to ON to enable support for USB Mass storage device.
- "NF_FEATURE_USE_SPIFFS": **`OFF`**
  - Set to ON to enable support for SPI flash file system.
- "ESP32_ETHERNET_SUPPORT" : **`OFF`**
  - Allows you to specify whether Ethernet support is available for ESP32. Default is `OFF`.
  Note that this API has the following sub options:
    - "ESP32_ETHERNET_INTERFACE":
      - Type of PHY or SPI device used leave empty to use default Lan8720.
    - "ETH_PHY_RST_GPIO"
      - GPIO number for PHY reset leave empty to use default of none.
    - "ETH_RMII_CLK_OUT_GPIO"
      - GPIO number that will output the RMII CLK signal leave empty if not used.
    - "ETH_RMII_CLK_IN_GPIO"
      - GPIO number that will be input for RMII CLK signal leave empty if not used.
    - "ETH_PHY_ADDR": ""
      - Address of the PHY chip leave empty to use default.
    - "ETH_MDC_GPIO": ""
      - GPIO number for SMI MDC pin leave empty to use default.
    - "ETH_MDIO_GPIO": ""
      - GPIO number for SMI MDIO pin leave empty to use default.
- "ESP32_CONFIG_PIN_PHY_POWER" : Not used?!
- "ESP32_CONFIG_PHY_CLOCK_MODE" : Not used?!
- "ESP32_SPIRAM_FOR_IDF_ALLOCATION" : ""
  - Set a value to reserve from SPI RAM for IDF allocation.
- "NF_TARGET_HAS_NANOBOOTER" : **`ON`**
  - Set to `OFF` to signal that target does not have nanoBooter.
- "USE_FPU" : **`OFF`**
  - Set to ON to enable FP usage. Depends on platform and MCU availability.

## Updating from CMake Variants

Please refer to [this blog post](https://www.nanoframework.net/build-updated-to-cmake-presets/) about the move to CMake presets.
