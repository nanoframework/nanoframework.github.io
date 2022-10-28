# CMake Presets

## About this document

This document describes how to use and modify the **CMakePresets.json** and **CMakeUserPresets.TEMPLATE.json** files to suit your needs.

## Build options for CMake Presets

Follows a list of the build options to use in the CMake presets.

- "BUILD_VERSION" : "**version-number-for-the-build-format-is-N.N.N.N**"
  - This can be used [to prevent a board from updating if working on a custom firmware](../faq/automatic-firmware-updates.md#how-to-prevent-a-board-from-updating-if-working-on-a-custom-firmware)
  - This can be used to workaround "[Found assemblies mismatches when checking for deployment pre-check](build-instructions.md#build_version-matching)" error during deployment.
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
- "USE_RNG" : "**ON**"
  - Option to enable the use of the hardware true random generator unit, if present. Default is ON as the majority of the targets have this feature.
- "DP_FLOATINGPOINT" : "**OFF**"
  - Enables support for double-precision floating point. The default is single-precision. Set to ON to enable double precision floating point.
- "SUPPORT_ANY_BASE_CONVERSION" : "**OFF**"
  - Defines which bases are supported when performing string to value conversions. When ON support for any base is enabled. When OFF (the default) the image will be compiled with support for base 10 and base 16 only.
- "RTOS" : "**one-of-valid-rtos-options**"
  - Defines the RTOS that will be used to build nanoFramework. Valid options: ChibiOS, ESP32, AzureRTOS and FreeRTOS.
- "CHIBIOS_SOURCE_FOLDER" : "**absolute-path-to-chibios-source-mind-the-forward-slash**"
  - Path to an optional local installation of ChibiOS source files. If no path is given, then CMake will download the sources automatically from the RTOS repository when required.
- "CHIBIOS_HAL_REQUIRED" : "**OFF**"
  - Set to ON to include ChibiOS HAL repository in the build.
- "SWO_OUTPUT" : "**OFF**"
  - Allows specifying whether to include, or not, support for Cortex-M Single Wire Output (SWO). Default is OFF. Check the documentation [here](../contributing/developing-native/arm-swo.md) for more details on how to use SWO.
- "NF_BUILD_RTM" : "**OFF**"
  - Sets if the build is of **R**eady **T**o **M**arket type. Meaning that all debug helpers and code blocks will be removed from compilation and the build will be compiled and linked with all possible code reducing options enabled.
- "NF_WP_TRACE_ERRORS" : "**OFF**"
  - Enable error tracing in Wire Protocol.
- "NF_WP_TRACE_HEADERS" :  "**OFF**"
  - Enable packet headers tracing in Wire Protocol.
- "NF_WP_TRACE_STATE" :  "**OFF**"
  - Enable state tracing in Wire Protocol.
- "NF_WP_TRACE_NODATA" :  "**OFF**"
  - Enable tracing of empty or incomplete packets in Wire Protocol.
- "NF_WP_TRACE_ALL" :  "**OFF**"
  - Enable all tracing options for Wire Protocol.
- "NF_WP_IMPLEMENTS_CRC32" :  "**ON**"
  - Enable CRC32 calculations for Wire Protocol. See details [here](../architecture/wire-protocol.md#crc32-validatons).
- "NF_FEATURE_DEBUGGER" : "**OFF**"
  - Defines is support for debuggin managed applications is enabled. Default is OFF.
- "NF_FEATURE_RTC" : "**OFF**"
  - Allows you to specify whether to use the real time clock unit of the hardware for date & time functions. Depends on target availability. Default is OFF.
- "NF_FEATURE_USE_APPDOMAINS" : "**OFF**"
  - Allows you to specify whether to include, or not, support for Application Domains. Default is OFF. More information about this is available in the documentation [here](https://msdn.microsoft.com/en-us/library/cxk374d9(v=vs.90).aspx). **Note that the complete removal of support for this feature is being considered (see issue [here](https://github.com/nanoframework/nf-interpreter/issues/303)).**
- "NF_FEATURE_WATCHDOG" : "**ON**"
  - Allows you to define it the hardware watchdog should be disabled.
   This setting can only be set to OFF for STM32 targets. ESP32 build enables this by default so there is no way to disable it.
   Default is ON, so the hardware watchdog will be enabled by default.
- "NF_FEATURE_HAS_CONFIG_BLOCK" : "**OFF**"
  - Allows the developer to set if the targets platform has configuration block.
  This requires the the block storage definition and the linker files add support for that.
  Default is OFF meaning that that the target DOES NOT have configuration block.
- "NF_PLATFORM_NO_CLR_TRACE" : "**OFF**"
  - Allows you to define if trace messages and checks are added to CLR or not.
  These checks are usually valuable when debugging issues within the CLR.
  Can and should be removed for RTM build flavours.
  Default is OFF meaning that all the standard trace and checks are added to the CLR.
- "NF_CLR_NO_IL_INLINE" : "**OFF**"
  - Allows you to define if CLR will use IL inlining.
  Default is OFF meaning that CLR will inline IL.
- "NF_INTEROP_ASSEMBLIES" : [ "Assembly1-Namespace", "Assembly2-Namespace" ]
  - Lists the name of the Interop assembly(ies) to be added to the build. Leave empty or don't add it if no Interop assembly is to be added.
- "NF_NETWORKING_SNTP" : "**ON**"
  - Allows you to specify whether SNTP is enabled. Requires networking feature to be enabled. Default is ON.
- "NF_SECURITY_MBEDTLS" : "**OFF**"
  - Enables support for secure sockets using mbedTLS. Default is OFF.
- "MBEDTLS_SOURCE" : "**OFF**"
  - Path to an optional local with mbedTLS source files.
- "API_nanoFramework.Device.OneWire" : "**OFF**"
  - Allows you to specify whether support for Devices.OneWire is available to your application. Default is OFF.
- "API_System.Devices.Dac" : "**OFF**"
  - Allows you to specify whether DAC functions are available to your application. Default is OFF.
- "API_System.Math" : "**OFF**"
  - Allows you to specify whether System.Math support is available to your application. Default is OFF.
- "API_System.Net" : "**OFF**"
  - Allows you to specify whether System.Net support is available to your application. Default is OFF.
- "API_nanoFramework.Device.Can" : "**OFF**"
  - Allows you to specify whether CAN bus functions are available to your application. Default is OFF.
- "API_Windows.Devices.Adc" : "**OFF**"
  - Allows you to specify whether ADC functions are available to your application. Default is OFF.
- "API_Windows.Devices.Gpio" : "**OFF**"
  - Allows you to specify whether GPIO functions are available to your application. Default is OFF.
- "API_Windows.Devices.I2c" : "**OFF**"
  - Allows you to specify whether I2C functions are available to your application. Default is OFF.
- "API_Windows.Devices.Pwm" : "**OFF**"
  - Allows you to specify whether PWM functions are available to your application. Default is OFF.
- "API_Windows.Devices.SerialCommunication" : "**OFF**"
  - Allows you to specify whether Serial Communication functions are available to your application. Default is OFF.
- "API_Windows.Devices.Spi" : "**OFF**"
  - Allows you to specify whether SPI functions are available to your application. Default is OFF.
- "API_Windows.Networking.Sockets" : "**OFF**"
  - Allows you to specify whether Networking Sockets functions are available to your application. Default is OFF.
- "API_Windows.Storage" : "**OFF**"
  - Allows you to specify whether Windows.Storage functions are available to your application. Default is OFF.
- "API_Hardware.Esp32" : "**OFF**"
  - Allows you to specify whether Hardware.Esp32 functions are available to your application. Default is OFF.
  Note that this API is exclusive of ESP32 targets and can't be used with any other.
- "API_Hardware.Stm32" : "**OFF**"
  - Allows you to specify whether Hardware.Stm32 functions are available to your application. Default is OFF.
  Note that this API is exclusive of STM32 targets and can't be used with any other.

Please refer to [this blog post](https://www.nanoframework.net/build-updated-to-cmake-presets/) about the move to CMake presets.
