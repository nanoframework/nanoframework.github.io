# CMake Presets

## About this document

This document describes how to use and modify the CMake presets to suit your needs.

> **Important:** Target and hardware/feature configuration has been migrated to [Kconfig](kconfig-options.md). CMake presets now only contain build-system settings (toolchain, generator, output paths, tool paths). For configuring target features, APIs, and hardware options see the [Kconfig options](kconfig-options.md) documentation.

## Introduction

Our build system uses [CMake](https://cmake.org/) and [CMake presets](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html) to configure the build-system level options.
The build can be managed and configured using a command prompt or directly from [VS Code](https://github.com/microsoft/vscode-cmake-tools/blob/main/docs/cmake-presets.md) or [Visual Studio](https://learn.microsoft.com/en-us/cpp/build/cmake-presets-vs?view=msvc-160).

CMake presets are now limited to build-system configuration. All hardware, feature and API configuration has moved to [Kconfig](kconfig-options.md) with per-target `defconfig` files.

Developer-local adjustments are split across two systems:

- **CMake-level**: `config/user-prefs.json` and `config/user-tools-repos.json` — for build type, build verbosity/version, tool paths, SDK paths and similar build-system variables.
- **Kconfig-level**: `config/user-kconfig.conf` — for target features, APIs, RTM mode, CLR trace flags and similar target configuration. See [Kconfig options](kconfig-options.md) for details.

## Build options for CMake Presets

Below is a list of the build options that **remain** in CMake presets. These are still defined in the current preset files and have **not** moved to Kconfig.

### In `config/user-prefs.json`

- `CMAKE_BUILD_TYPE`: `Debug`
  - Build type for the CMake configure preset.
- `BUILD_VERSION`: `N.N.N.N`
  - This can be used [to prevent a board from updating if working on a custom firmware](../faq/automatic-firmware-updates.md).
  - This can be used to work around the "[Found assemblies mismatches when checking for deployment pre-check](build-instructions.md#preparation)" error during deployment.
- `BUILD_VERBOSE`: `OFF`
  - Enables verbose build-system output.

### In `config/user-tools-repos.json`

- `TOOL_HEX2DFU_PREFIX`
  - Path to the HEX2DFU utility. Use forward slashes and do not include the executable name.
- `TOOL_SRECORD_PREFIX`
  - Path to the SRecord utility. Use forward slashes and do not include the executable name.
- `CHIBIOS_SOURCE_FOLDER`
  - Optional path to a local ChibiOS source tree.
- `CHIBIOS_HAL_SOURCE`
  - Optional path to a local ChibiOS HAL source tree.
- `CHIBIOS_CONTRIB_SOURCE`
  - Optional path to a local ChibiOS Contrib source tree.
- `FREERTOS_SOURCE_FOLDER`
  - Optional path to a local FreeRTOS source tree.
- `STM32_HAL_DRIVER_SOURCE`
  - Optional path to local STM32 HAL driver sources.
- `STM32_CMSIS_DEVICE_SOURCE`
  - Optional path to local STM32 CMSIS device sources.
- `STM32_CMSIS_CORE_SOURCE`
  - Optional path to local STM32 CMSIS core sources.
- `LWIP_SOURCE`
  - Optional path to a local lwIP source tree.
- `MBEDTLS_SOURCE`
  - Optional path to a local mbedTLS source tree.
- `FATFS_SOURCE`
  - Optional path to a local FatFS source tree.
- `LITTLEFS_SOURCE`
  - Optional path to a local littlefs source tree.
- `ESP32_IDF_PATH`
  - Path to the ESP-IDF folder. Use forward slashes.
- `TI_SL_CC32xx_SDK_SOURCE`
  - Optional path to a local TI SimpleLink CC32xx SDK source tree.
- `TI_SL_CC13xx_26xx_SDK_SOURCE`
  - Optional path to a local TI SimpleLink CC13xx/26xx SDK source tree.
- `TI_XDCTOOLS_SOURCE`
  - Optional path to local TI XDC Tools.
- `TI_SYSCONFIG_SOURCE`
  - Optional path to local TI SysConfig.
- `THREADX_SOURCE_FOLDER`
  - Optional path to a local ThreadX source tree.
- `NETXDUO_SOURCE_FOLDER`
  - Optional path to a local NetX Duo source tree.

### In toolchain and target presets

- `NF_INTEROP_ASSEMBLIES`: `Assembly1-Namespace Assembly2-Namespace Assembly3-Namespace`
  - Lists the Interop assemblies to add to the build as a space-separated string. Leave empty if none are required.
- `NF_TARGET_DEFCONFIG`: `path-to-target-defconfig-file`
  - Path to the Kconfig `defconfig` file for the target board. This is the only target-specific variable that still remains in the target CMake presets.

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

## Migration to Kconfig options

Please refer to the [blog post about moving to Kconfig](https://nanoframework.net/build-configuration-updated-to-kconfig-options/) for information about the transition to Kconfig from CMake presets.
