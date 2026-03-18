# CMake Presets

## About this document

This document describes how to use and modify the CMake presets to suit your needs.

> **Important:** Target and hardware/feature configuration has been migrated to [Kconfig](kconfig-options.md). CMake presets now only contain build-system settings (toolchain, generator, output paths, tool paths). For configuring target features, APIs, and hardware options see the [Kconfig options](kconfig-options.md) documentation.

## Introduction

Our build system uses [CMake](https://cmake.org/) and [CMake presets](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html) to configure the build-system level options.
The build can be managed and configured using a command prompt or directly from [VS Code](https://github.com/microsoft/vscode-cmake-tools/blob/main/docs/cmake-presets.md) or [Visual Studio](https://learn.microsoft.com/en-us/cpp/build/cmake-presets-vs?view=msvc-160).

CMake presets are now limited to build-system configuration. All hardware, feature and API configuration has moved to [Kconfig](kconfig-options.md) with per-target `defconfig` files.

Developer-local adjustments are split across two systems:

- **CMake-level**: `config/user-prefs.json` — for build type, tool paths, SDK paths, build version and similar build-system variables.
- **Kconfig-level**: `config/user-kconfig.conf` — for target features, APIs, RTM mode, CLR trace flags and similar target configuration. See [Kconfig options](kconfig-options.md) for details.

## Build options for CMake Presets

Below is a list of the build options that **remain** in CMake presets. These are build-system variables that are not part of target configuration.

- "BUILD_VERSION" : "**version-number-for-the-build-format-is-N.N.N.N**"
  - This can be used [to prevent a board from updating if working on a custom firmware](../faq/automatic-firmware-updates.md)
  - This can be used to workaround "[Found assemblies mismatches when checking for deployment pre-check](build-instructions.md#preparation)" error during deployment.
- "BUILD_VERBOSE"
  - Option to output verbose messages during build. Useful for debugging issues with build system.
- "TOOL_HEX2DFU_PREFIX" : "**absolute-path-to-hex2dfu-utility-mind-the-forward-slash**"
  - This is the path to the HEX2DFU utility. Use forward slashes and do not provide executable name here.
- "TOOL_SRECORD_PREFIX" : "**absolute-path-to-srecord-utility-mind-the-forward-slash**"
  - This is the path to the SRecord utility. Use forward slashes and do not provide executable name here.
- "ESP32_IDF_PATH" : "**absolute-path-to-esp-idf-mind-the-forward-slash**"
  - This the path to the ESP32 IDF utility. Use forward slashes and do not provide executable name here.
- "EXECUTABLE_OUTPUT_PATH" : "**${workspaceRoot}/build**"
  - This is the default and recommended path which will expand to the build folder when building from VS Code. When building from the command line or from Visual Studio this is not required.
- "CHIBIOS_SOURCE_FOLDER" : ""
  - Path to an optional local installation of ChibiOS source files. If no path is given, then CMake will download the sources automatically from ChibiOS SVN repository when required. Mind the forward slash.
- "CHIBIOS_HAL_SOURCE": ""
  - Path to an optional local installation of ChibiOS HAL source files. If no path is given, then CMake will download the sources automatically from ChibiOS SVN repository when required. Mind the forward slash.
- "CHIBIOS_CONTRIB_SOURCE": ""
  - Path to an optional local installation of ChibiOS Contrib source files. If no path is given, then CMake will download the sources automatically from ChibiOS Contrib repository when required. Mind the forward slash.
- "FREERTOS_SOURCE_FOLDER": ""
  - Path to an optional local installation of FreeRTOS source files. If no path is given, then CMake will download the sources automatically from FreeRTOS repository when required. Mind the forward slash.
- "CMSIS_SOURCE": ""
  - Path to an optional local installation of CMSIS source files. If no path is given, then CMake will download the sources automatically from CMSIS repository when required. Mind the forward slash.
- "STM32_HAL_DRIVER_SOURCE": ""
  - Path to an optional local installation of STM32 HAL driver source files. If no path is given, then CMake will download the sources automatically. Mind the forward slash.
- "STM32_CMSIS_DEVICE_SOURCE": ""
  - Path to an optional local installation of CMSIS device source files. If no path is given, then CMake will download the sources automatically. Mind the forward slash.
- "STM32_CMSIS_CORE_SOURCE": ""
  - Path to an optional local installation of STM32 CMSIS source files. If no path is given, then CMake will download the sources automatically. Mind the forward slash.
- "TI_SL_CC32xx_SDK_SOURCE": ""
  - Path to an optional local installation of TI SimpleLink CC32xx SDK source files. If no path is given, then CMake will download the sources automatically. Mind the forward slash.
- "TI_SL_CC13xx_26xx_SDK_SOURCE": ""
  - Path to an optional local installation of TI SimpleLink CC13xx_26xx SDK source files. If no path is given, then CMake will download the sources automatically. Mind the forward slash.
- "TI_XDCTOOLS_SOURCE": ""
  - Path to an optional local installation of TI XDC Tools source files. If no path is given, then CMake will download the sources automatically. Mind the forward slash.
- "TI_SYSCONFIG_SOURCE": ""
  - Path to an optional local installation of TI SysConfig source files. If no path is given, then CMake will download the sources automatically. Mind the forward slash.
- "LITTLEFS_SOURCE": ""
  - Path to an optional local installation of littlefs source files. If no path is given, then CMake will download the sources automatically. Mind the forward slash.
- "FATFS_SOURCE": ""
  - Path to an optional local installation of FatFS source files. If no path is given, then CMake will download the sources automatically. Mind the forward slash.
- "MBEDTLS_SOURCE" : ""
  - Path to an optional local with mbedTLS source files.
- "NF_INTEROP_ASSEMBLIES" : "Assembly1-Namespace Assembly2-Namespace Assembly3-Namespace"
  - Lists the name of the Interop assembly(ies) to be added to the build in a space separated string. Leave empty or don't add it if no Interop assembly is to be added.
- "NF_TARGET_DEFCONFIG" : "**path-to-target-defconfig-file**"
  - Path to the Kconfig defconfig file for the target board. This is the only target-specific variable in a CMake preset. All hardware/feature/API configuration is read from this defconfig file by the Kconfig system.

## Deprecated CMake Preset Options

The following options have been **migrated to [Kconfig](kconfig-options.md)** and are no longer set in CMake presets. See the [Kconfig options](kconfig-options.md) page for their Kconfig equivalents.

### Platform identity (now in Kconfig)

- `TARGET_BOARD`, `TARGET_SERIES`, `RTOS`

### Build mode flags (now in Kconfig)

- `NF_BUILD_RTM`, `NF_TARGET_HAS_NANOBOOTER`, `NF_SECURITY_MBEDTLS`, `NF_ENABLE_DOUBLE_PRECISION_FP`, `NF_SUPPORT_ANY_BASE_CONVERSION`, `NF_FEATURE_USE_RNG`

### nF features (now in Kconfig)

- `NF_FEATURE_DEBUGGER`, `NF_FEATURE_RTC`, `NF_FEATURE_HAS_SDCARD`, `NF_FEATURE_HAS_CONFIG_BLOCK`, `NF_FEATURE_USE_LITTLEFS`, `NF_FEATURE_HAS_USB_MSD`, `NF_FEATURE_HAS_ACCESSIBLE_STORAGE`, `NF_FEATURE_WATCHDOG`, `NF_FEATURE_SUPPORT_REFLECTION`, `NF_FEATURE_BINARY_SERIALIZATION`, `NF_FEATURE_LIGHT_MATH`, `NF_FEATURE_USE_APPDOMAINS`

### Wire Protocol (now in Kconfig)

- `NF_WP_TRACE_ERRORS`, `NF_WP_TRACE_HEADERS`, `NF_WP_TRACE_STATE`, `NF_WP_TRACE_NODATA`, `NF_WP_TRACE_ALL`, `NF_WP_ENABLE_CRC32`

### CLR options (now in Kconfig)

- `NF_CLR_NO_TRACE`, `NF_CLR_NO_IL_INLINE`, `NF_TRACE_TO_STDIO`

### Wire Protocol transport (now in Kconfig)

- `NF_WP_TRANSPORT_SERIAL`, `NF_WP_TRANSPORT_USB_CDC`, `TARGET_SERIAL_BAUDRATE`

### API selection (now in Kconfig)

- All `API_System.*`, `API_nanoFramework.*`, `API_Hardware.*`, `API_Windows.*` variables

### Graphics (now in Kconfig)

- `GRAPHICS_DISPLAY`, `GRAPHICS_DISPLAY_INTERFACE`, `TOUCHPANEL_DEVICE`, `TOUCHPANEL_INTERFACE`, `GRAPHICS_MEMORY`

### ESP32-specific (now in Kconfig)

- `ESP32_ETHERNET_SUPPORT`, `ESP32_ETHERNET_INTERFACE`, `ESP32_USB_CDC`, `ESP32_RESERVE_SPIRAM_IDF_ALLOCATION_BYTES`, `ESP32_XTAL_FREQ_26`, `SDK_CONFIG_FILE`

### STM32/ChibiOS-specific (now in Kconfig)

- `THREADX_CHIBIOS_HAL_REQUIRED`, `CHIBIOS_CONTRIB_REQUIRED`, `STM32_CUBE_PACKAGE_REQUIRED`, `CHIBIOS_SWO_OUTPUT`, `TARGET_NAME`

### TI SimpleLink-specific (now in Kconfig)

- `TI_SIMPLELINK_RADIO_FREQ_MHZ`

### Networking (now in Kconfig)

- `NF_NETWORKING_SNTP`
- "NF_FEATURE_HAS_USB_MSD" : **`OFF`**
  - Set to ON to enable support for USB Mass storage device.
- "NF_FEATURE_USE_SPIFFS": **`OFF`**
  - Set to ON to enable support for SPI flash file system.
- "ESP32_ETHERNET_SUPPORT" : **`OFF`**
  - Allows you to specify whether Ethernet support is available for ESP32. Default is `OFF`.
  Note that this API has the following sub options:
    - "ESP32_ETHERNET_INTERFACE":
      - Type of PHY or SPI device used leave empty to use default Lan8720.
    - "ESP32_ETHERNET_PHY_RST_GPIO"
      - GPIO number for PHY reset leave empty to use default of none.
    - "ESP32_ETHERNET_RMII_CLK_OUT_GPIO"
      - GPIO number that will output the RMII CLK signal leave empty if not used.
    - "ESP32_ETHERNET_RMII_CLK_IN_GPIO"
      - GPIO number that will be input for RMII CLK signal leave empty if not used.
    - "ESP32_ETHERNET_PHY_ADDR": ""
      - Address of the PHY chip leave empty to use default.
    - "ESP32_ETHERNET_MDC_GPIO": ""
      - GPIO number for SMI MDC pin leave empty to use default.
    - "ESP32_ETHERNET_MDIO_GPIO": ""
      - GPIO number for SMI MDIO pin leave empty to use default.
- "ESP32_ETHERNET_PHY_POWER_PIN" : ""
  - Ethernet PHY power pin override.
- "ESP32_ETHERNET_PHY_CLOCK_MODE" : ""
  - Ethernet PHY clock mode override.
- "ESP32_RESERVE_SPIRAM_IDF_ALLOCATION_BYTES" : ""
  - Set a value to reserve from SPI RAM for IDF allocation.
- "NF_TARGET_HAS_NANOBOOTER" : **`ON`**
  - Set to `OFF` to signal that target does not have nanoBooter.
- "USE_FPU" : **`OFF`**
  - Set to ON to enable FP usage. Depends on platform and MCU availability.
- "GECKO_DEVICE_CLASS_VENDOR_DESCRIPTION_LENGTH" : **""**
  - Set to a value <= 256 to override the allowed length of USB device class vendor description. Only available on Giant Gecko S1 platform.

## Updating from CMake Variants

Please refer to the [blog post about moving to CMake presets](https://www.nanoframework.net/build-updated-to-cmake-presets/) for information about the transition from CMake Variants.
