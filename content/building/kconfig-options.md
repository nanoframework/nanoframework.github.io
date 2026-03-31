# Kconfig Target Configuration

## About this document

This document describes the Kconfig-based target configuration system used to configure hardware features, APIs and build options for .NET **nanoFramework** firmware targets.

## Introduction

Target and hardware/feature configuration uses [Kconfig](https://www.kernel.org/doc/html/latest/kbuild/kconfig-language.html), powered by [kconfiglib](https://github.com/ulfalizer/Kconfiglib) (a pure-Python implementation). CMake presets remain for build-system configuration (toolchain, generator, output paths, tool paths) — see [CMake presets](cmake-presets.md).

Each target board has a `defconfig` file that contains only the non-default configuration values. Kconfig fills in all remaining options with their defaults, enforces dependencies and validates the configuration at configure time.

### Prerequisites

- [Python 3.8](https://www.python.org/downloads/) or later.
- [kconfiglib](https://github.com/ulfalizer/Kconfiglib): install with `pip install kconfiglib`.

### Key benefits

- **Interactive configuration**: use `menuconfig` to discover and toggle options.
- **Declarative dependencies**: `depends on`, `select` and `imply` replace hardcoded CMakeLists.txt conditionals.
- **Minimal defconfig files**: only non-default values are stored, reducing per-target boilerplate.
- **Validation**: Kconfig enforces constraints at configuration time, not at build time.

## Developer Workflow

### Building an existing target

The workflow is unchanged from the developer's perspective:

```bash
cmake --preset ESP32_PSRAM_REV0
cmake --build --preset ESP32_PSRAM_REV0
```

The preset loads the defconfig automatically via the `NF_TARGET_DEFCONFIG` cache variable. If `config/user-kconfig.conf` is present, its preferences are merged on top transparently.

### Applying developer-local preferences

Developer-local Kconfig preferences (RTM mode, CLR trace flags, Wire Protocol options, etc.) are set in `config/user-kconfig.conf`:

```bash
# First time only — copy the template
cp config/user-kconfig.conf.TEMPLATE config/user-kconfig.conf
```

Edit the file using standard Kconfig fragment format:

```text
CONFIG_NF_BUILD_RTM=n
CONFIG_NF_CLR_NO_TRACE=n
CONFIG_NF_CLR_NO_IL_INLINE=n
CONFIG_NF_WP_TRACE_ERRORS=n
CONFIG_NF_WP_ENABLE_CRC32=n
```

This file is git-ignored. Only symbols explicitly listed in the overlay are modified; everything else comes from the board defconfig.

### Interactive configuration with menuconfig

```bash
# Load defconfig into .config
python -m defconfig targets/ESP32/defconfig/ESP32_PSRAM_REV0_defconfig

# Open menu-driven configuration
python -m menuconfig

# Build as usual
cmake --preset ESP32_PSRAM_REV0
cmake --build --preset ESP32_PSRAM_REV0
```

### Creating a new target

```bash
# Start from closest existing defconfig
cp targets/ESP32/defconfig/ESP32_PSRAM_REV0_defconfig targets/ESP32/defconfig/MY_BOARD_defconfig

# Edit interactively
export KCONFIG_CONFIG=build/.config
python -m defconfig targets/ESP32/defconfig/MY_BOARD_defconfig
python -m menuconfig

# Save minimal defconfig (only non-default values)
python -m savedefconfig --out targets/ESP32/defconfig/MY_BOARD_defconfig
```

### Modifying an existing target configuration

```bash
# Load and open for editing
python -m defconfig targets/ChibiOS/ST_STM32F769I_DISCOVERY/defconfig
python -m menuconfig

# Save back
python -m savedefconfig --out targets/ChibiOS/ST_STM32F769I_DISCOVERY/defconfig
```

## Directory Structure

```text
nf-interpreter/
├── Kconfig                              # Root — sources everything
├── Kconfig.rtos                         # RTOS selection
├── Kconfig.features                     # NF_FEATURE_* options with dependencies
├── Kconfig.apis                         # API selection with auto-select dependencies
├── Kconfig.graphics                     # Graphics display/touch subsystem
├── Kconfig.networking                   # Networking, Ethernet, WiFi, Thread
├── Kconfig.serial                       # Wire Protocol transport (UART / USB CDC)
├── Kconfig.wireprotocol                 # Wire Protocol options and trace flags
├── Kconfig.build                        # RTM, floating point, base conversion, etc.
│
├── config/
│   ├── user-kconfig.conf.TEMPLATE       # Template for Kconfig-level user preferences
│   └── user-kconfig.conf                # Developer local copy — git-ignored
│
├── targets/
│   ├── ESP32/
│   │   ├── Kconfig                      # ESP32 family options
│   │   ├── Kconfig.ethernet             # ESP32 Ethernet PHY configuration
│   │   └── defconfig/                   # Flat directory — ESP32 variants
│   │       ├── ESP32_PSRAM_REV0_defconfig
│   │       ├── ESP32_BLE_REV0_defconfig
│   │       └── ...
│   │
│   ├── ChibiOS/
│   │   ├── Kconfig                      # ChibiOS/STM32-specific options
│   │   └── <board>/
│   │       └── defconfig                # Per-board defconfig
│   │
│   ├── FreeRTOS/
│   │   ├── Kconfig
│   │   └── NXP/<board>/defconfig
│   │
│   ├── TI_SimpleLink/
│   │   ├── Kconfig
│   │   └── <board>/defconfig
│   │
│   └── ThreadX/
│       ├── Kconfig
│       └── <vendor>/<board>/defconfig
```

## Kconfig Options Reference

### Platform Identity

| Kconfig Symbol | Type | Description |
|---|---|---|
| `TARGET_BOARD` | string | Target board name |
| `TARGET_SERIES` | string | Target MCU series (e.g. `STM32F7xx`, `ESP32`, `IMXRT10xx`) |
| `RTOS` | choice | RTOS selection: `ESP32`, `ChibiOS`, `FreeRTOS`, `TI_SimpleLink`, `ThreadX` |

### Build Options

| Kconfig Symbol | Type | Default | Description |
|---|---|---|---|
| `NF_BUILD_RTM` | bool | n | Build RTM firmware (suppresses debug output, removes all debugger features) |
| `NF_TARGET_HAS_NANOBOOTER` | bool | y | Target includes nanoBooter |
| `NF_ENABLE_DOUBLE_PRECISION_FP` | bool | n | Enable double-precision floating point (default is single-precision) |
| `NF_SUPPORT_ANY_BASE_CONVERSION` | bool | n | Enable string conversion for any numeric base (default: base 10 and 16 only) |
| `NF_FEATURE_USE_RNG` | bool | y | Enable hardware true random number generator |
| `NF_SECURITY_MBEDTLS` | bool | y | Enable Mbed TLS support for secure sockets |
| `NF_CLR_NO_TRACE` | bool | n | Remove trace messages and checks from CLR |
| `NF_CLR_NO_IL_INLINE` | bool | n | Disable IL inlining in CLR |

### nanoFramework Features

| Kconfig Symbol | Type | Default | Description |
|---|---|---|---|
| `NF_FEATURE_DEBUGGER` | bool | y | Managed application debugging support |
| `NF_FEATURE_RTC` | bool | n | Hardware RTC support |
| `NF_FEATURE_HAS_SDCARD` | bool | n | SD Card support |
| `NF_FEATURE_HAS_CONFIG_BLOCK` | bool | n | Configuration block storage |
| `NF_FEATURE_USE_LITTLEFS` | bool | n | LittleFS file system |
| `NF_FEATURE_HAS_ACCESSIBLE_STORAGE` | bool | n | Accessible storage (internal storage) |
| `NF_FEATURE_HAS_USB_MSD` | bool | n | USB Mass Storage |
| `NF_FEATURE_WATCHDOG` | bool | y | Hardware watchdog |
| `NF_FEATURE_SUPPORT_REFLECTION` | bool | y | System.Reflection API support |
| `NF_FEATURE_BINARY_SERIALIZATION` | bool | y | Binary serialization support |
| `NF_FEATURE_USE_APPDOMAINS` | bool | n | Application Domains support |
| `NF_FEATURE_LIGHT_MATH` | bool | n | Light math (exclude complex math functions) |
| `NF_TRACE_TO_STDIO` | bool | n | Enable trace messages to stdio |

### Wire Protocol

| Kconfig Symbol | Type | Default | Description |
|---|---|---|---|
| `NF_WP_TRACE_ERRORS` | bool | n | Enable error tracing in Wire Protocol |
| `NF_WP_TRACE_HEADERS` | bool | n | Enable packet headers tracing |
| `NF_WP_TRACE_STATE` | bool | n | Enable state tracing |
| `NF_WP_TRACE_NODATA` | bool | n | Enable tracing of empty or incomplete packets |
| `NF_WP_TRACE_VERBOSE` | bool | n | Enable verbose tracing |
| `NF_WP_TRACE_ALL` | bool | n | Enable all tracing options |
| `NF_WP_ENABLE_CRC32` | bool | n | Enable CRC32 calculations. See [Wire Protocol details](../architecture/wire-protocol.md#crc32-validations) |

### Wire Protocol Transport

| Kconfig Symbol | Type | Default | Description |
|---|---|---|---|
| `NF_WP_TRANSPORT_SERIAL` | bool | y | Use serial (UART) for Wire Protocol (default transport) |
| `NF_WP_TRANSPORT_USB_CDC` | bool | n | Use USB CDC for Wire Protocol |
| `TARGET_SERIAL_BAUDRATE` | int | 921600 | Baudrate for serial communication (depends on `NF_WP_TRANSPORT_SERIAL`) |

### API Selection

API options follow the pattern `API_<name>` in Kconfig. Kconfig automatically enforces dependencies between APIs.

| Kconfig Symbol | Type | Default | Description |
|---|---|---|---|
| `API_SYSTEM_MATH` | bool | y | System.Math |
| `API_SYSTEM_NET` | bool | n | System.Net (auto-selects `NF_FEATURE_HAS_CONFIG_BLOCK`) |
| `API_SYSTEM_DEVICE_GPIO` | bool | y | System.Device.Gpio |
| `API_SYSTEM_DEVICE_SPI` | bool | n | System.Device.Spi |
| `API_SYSTEM_DEVICE_I2C` | bool | n | System.Device.I2c |
| `API_SYSTEM_DEVICE_I2C_SLAVE` | bool | n | System.Device.I2c.Slave (depends on `API_SYSTEM_DEVICE_I2C`) |
| `API_SYSTEM_DEVICE_PWM` | bool | n | System.Device.Pwm |
| `API_SYSTEM_DEVICE_ADC` | bool | n | System.Device.Adc |
| `API_SYSTEM_DEVICE_DAC` | bool | n | System.Device.Dac |
| `API_SYSTEM_DEVICE_I2S` | bool | n | System.Device.I2s |
| `API_SYSTEM_DEVICE_WIFI` | bool | n | System.Device.Wifi |
| `API_SYSTEM_DEVICE_USBSTREAM` | bool | n | System.Device.UsbStream |
| `API_SYSTEM_IO_PORTS` | bool | n | System.IO.Ports (auto-selects `API_NANOFRAMEWORK_SYSTEM_TEXT`) |
| `API_SYSTEM_IO_FILESYSTEM` | bool | n | System.IO.FileSystem (depends on `NF_FEATURE_HAS_SDCARD`, `NF_FEATURE_USE_LITTLEFS` or `NF_FEATURE_HAS_USB_MSD`) |
| `API_NANOFRAMEWORK_DEVICE_ONEWIRE` | bool | n | nanoFramework.Device.OneWire |
| `API_NANOFRAMEWORK_DEVICE_CAN` | bool | n | nanoFramework.Device.Can |
| `API_NANOFRAMEWORK_DEVICE_BLUETOOTH` | bool | n | nanoFramework.Device.Bluetooth |
| `API_NANOFRAMEWORK_GRAPHICS` | bool | n | nanoFramework.Graphics |
| `API_NANOFRAMEWORK_RESOURCEMANAGER` | bool | n | nanoFramework.ResourceManager |
| `API_NANOFRAMEWORK_SYSTEM_COLLECTIONS` | bool | n | nanoFramework.System.Collections |
| `API_NANOFRAMEWORK_SYSTEM_TEXT` | bool | n | nanoFramework.System.Text |
| `API_NANOFRAMEWORK_SYSTEM_SECURITY_CRYPTOGRAPHY` | bool | n | nanoFramework.System.Security.Cryptography (depends on `NF_SECURITY_MBEDTLS`) |
| `API_NANOFRAMEWORK_SYSTEM_IO_HASHING` | bool | n | nanoFramework.System.IO.Hashing |
| `API_NANOFRAMEWORK_NETWORKING_THREAD` | bool | n | nanoFramework.Networking.Thread |

### Platform-Specific APIs

These APIs are only visible when the corresponding RTOS is selected.

| Kconfig Symbol | Type | Depends On | Description |
|---|---|---|---|
| `API_HARDWARE_ESP32` | bool | `RTOS_ESP32` | Hardware.Esp32 |
| `API_NANOFRAMEWORK_HARDWARE_ESP32_RMT` | bool | `RTOS_ESP32` | nanoFramework.Hardware.Esp32.Rmt |
| `API_HARDWARE_STM32` | bool | `RTOS_CHIBIOS` | Hardware.Stm32 |
| `API_NANOFRAMEWORK_HARDWARE_TI` | bool | `RTOS_TI_SIMPLELINK` | nanoFramework.Hardware.TI |
| `API_NANOFRAMEWORK_TI_EASYLINK` | bool | `RTOS_TI_SIMPLELINK` | nanoFramework.TI.EasyLink |
| `API_HARDWARE_GIANTGECKO` | bool | `RTOS_THREADX` | Hardware.GiantGecko |
| `API_NANOFRAMEWORK_GIANTGECKO_ADC` | bool | `RTOS_THREADX` | nanoFramework.GiantGecko.Adc |

### Graphics Options

These options are available when `API_NANOFRAMEWORK_GRAPHICS` is enabled.

| Kconfig Symbol | Type | Description |
|---|---|---|
| `GRAPHICS_DISPLAY` | choice | Display driver: ILI9341, ILI9342, ST7735S, ST7789V, GC9A01, Otm8009a (DSI), Generic SPI |
| `GRAPHICS_DISPLAY_INTERFACE` | choice | Display interface: SPI to Display, DSI Video Mode |
| `TOUCHPANEL_DEVICE` | choice | Touch panel driver: XPT2046, ft6x06, CST816S (optional) |
| `TOUCHPANEL_INTERFACE` | choice | Touch panel interface: SPI, I2C (optional) |
| `GRAPHICS_MEMORY` | string | Graphics memory implementation |

### ESP32-Specific Options

Available when RTOS is set to ESP32.

| Kconfig Symbol | Type | Default | Description |
|---|---|---|---|
| `SDK_CONFIG_FILE` | string | "" | Path to IDF sdkconfig defaults file |
| `ESP32_RESERVE_SPIRAM_IDF_ALLOCATION_BYTES` | int | 262144 | SPIRAM reserved for IDF allocation (bytes) |
| `ESP32_USB_CDC` | bool | n | USB CDC for Wire Protocol |
| `ESP32_XTAL_FREQ_26` | bool | n | 26 MHz crystal (instead of 40 MHz default) |
| `ESP32_RESERVE_IRAM_IDF_ALLOCATION_KB` | int | 0 | RAM reserved for IDF allocation (kB, for limited-memory boards) |
| `ESP32_ETHERNET_SUPPORT` | bool | n | Enable Ethernet support |
| `ESP32_THREAD_DEVICE_TYPE` | string | "" | Thread device type |
| `ESP32_ETHERNET_PHY_CLOCK_MODE` | string | "" | Ethernet PHY clock mode override |
| `ESP32_ETHERNET_PHY_POWER_PIN` | string | "" | Ethernet PHY power pin override |

#### ESP32 Ethernet Sub-options

Available when `ESP32_ETHERNET_SUPPORT` is enabled.

| Kconfig Symbol | Type | Default | Description |
|---|---|---|---|
| `ESP32_ETHERNET_INTERFACE` | choice | — | Ethernet PHY: IP101, LAN8720, RTL8201 |
| `ESP32_ETHERNET_PHY_ADDR` | int | 1 | Ethernet PHY address |
| `ESP32_ETHERNET_MDC_GPIO` | int | 23 | MDC GPIO pin |
| `ESP32_ETHERNET_MDIO_GPIO` | int | 18 | MDIO GPIO pin |
| `ESP32_ETHERNET_RMII_CLK_OUT_GPIO` | int | -1 | RMII clock output GPIO pin (-1 = not used) |
| `ESP32_ETHERNET_RMII_CLK_IN_GPIO` | int | -1 | RMII clock input GPIO pin (-1 = not used) |
| `ESP32_ETHERNET_PHY_RST_GPIO` | int | -1 | Ethernet PHY reset GPIO pin (-1 = not used) |

### ChibiOS/STM32-Specific Options

Available when RTOS is set to ChibiOS.

| Kconfig Symbol | Type | Default | Description |
|---|---|---|---|
| `CHIBIOS_CONTRIB_REQUIRED` | bool | n | Include ChibiOS Contrib repository in the build |
| `STM32_CUBE_PACKAGE_REQUIRED` | bool | n | Include STM Cube package in the build |
| `CHIBIOS_SWO_OUTPUT` | bool | n | Support for Cortex-M Single Wire Output (SWO). See [SWO details](../contributing/developing-native/arm-swo.md) |

### ThreadX-Specific Options

Available when RTOS is set to ThreadX.

| Kconfig Symbol | Type | Default | Description |
|---|---|---|---|
| `GECKO_FEATURE_USBD_HID` | bool | n | Gecko USB HID device support |
| `STM32_CUBE_PACKAGE_REQUIRED` | bool | n | Include STM Cube package in the build |
| `THREADX_CHIBIOS_HAL_REQUIRED` | bool | n | ChibiOS HAL required (for STM32 WiFi targets) |
| `THREADX_WIFI_DRIVER` | string | "" | WiFi driver name (e.g. ISM43362) |

### TI SimpleLink-Specific Options

Available when RTOS is set to TI SimpleLink.

| Kconfig Symbol | Type | Default | Description |
|---|---|---|---|
| `TI_SIMPLELINK_RADIO_FREQ_MHZ` | int | 915 | Radio frequency for CC13xx_26xx targets (868 or 915) |

### Networking Options

| Kconfig Symbol | Type | Default | Description |
|---|---|---|---|
| `NF_NETWORKING_SNTP` | bool | y | Enable SNTP (requires networking feature) |
| `NF_NETWORKING_ENC28J60` | bool | n | Enable ENC28J60 Ethernet controller support |

## Defconfig File Example

A typical defconfig file for an ESP32 target (`targets/ESP32/defconfig/ESP32_PSRAM_REV0_defconfig`):

```text
CONFIG_TARGET_BOARD="ESP32"
CONFIG_TARGET_SERIES="ESP32"
CONFIG_RTOS_ESP32=y

CONFIG_NF_FEATURE_DEBUGGER=y
CONFIG_NF_FEATURE_RTC=y
CONFIG_NF_FEATURE_HAS_SDCARD=y

CONFIG_API_SYSTEM_MATH=y
CONFIG_API_SYSTEM_DEVICE_ADC=y
CONFIG_API_SYSTEM_DEVICE_DAC=y
CONFIG_API_SYSTEM_DEVICE_GPIO=y
CONFIG_API_SYSTEM_DEVICE_I2C=y
CONFIG_API_SYSTEM_DEVICE_PWM=y
CONFIG_API_SYSTEM_IO_PORTS=y
CONFIG_API_SYSTEM_DEVICE_SPI=y
CONFIG_API_NANOFRAMEWORK_DEVICE_ONEWIRE=y
CONFIG_API_NANOFRAMEWORK_RESOURCEMANAGER=y
CONFIG_API_NANOFRAMEWORK_SYSTEM_COLLECTIONS=y
CONFIG_API_NANOFRAMEWORK_SYSTEM_TEXT=y

CONFIG_ESP32_RESERVE_SPIRAM_IDF_ALLOCATION_BYTES=262144
```

Only non-default values appear in the defconfig. Kconfig fills in the rest.

## CMake Integration

The Kconfig system integrates with CMake through `NF_Kconfig.cmake`. During configuration:

1. `scripts/nf_merge_config.py` merges the board defconfig with the optional `config/user-kconfig.conf` overlay into `build/.config`.
2. `genconfig` produces `build/.config` and `build/nf_config.h`.
3. `NF_Kconfig.cmake` parses `.config` into CMake cache variables.

Kconfig symbol names are mapped to CMake variable names automatically:

| Kconfig symbol | CMake variable |
|---|---|
| `CONFIG_NF_FEATURE_DEBUGGER=y` | `NF_FEATURE_DEBUGGER=ON` |
| `CONFIG_API_SYSTEM_DEVICE_GPIO=y` | `API_System.Device.Gpio=ON` |
| `CONFIG_API_NANOFRAMEWORK_GRAPHICS=y` | `API_nanoFramework.Graphics=ON` |
| `CONFIG_TARGET_BOARD="ESP32"` | `TARGET_BOARD=ESP32` |
| `CONFIG_RTOS="ChibiOS"` | `RTOS=ChibiOS` |

All existing CMake modules continue to work unchanged.
