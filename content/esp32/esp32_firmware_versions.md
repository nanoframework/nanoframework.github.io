# ESP32 Firmware versions

The firmware versions are:-

| Firmware name   | WiFi               | Ethernet           | Bluetooth          | PSRAM(Large heap)  | ESP32 version |
| WROOM_32        | :heavy_check_mark: |                    |                    | :heavy_check_mark: | 0 -> 3 |
| WROOM_32_BLE    | :heavy_check_mark: |                    | :heavy_check_mark: |                    | 0 -> 3 |
| WROOM_32_V3_BLE | Version 3 Only     |                    | :heavy_check_mark: | :heavy_check_mark: | 3 only |
| ESP_WROVER_KIT  | :heavy_check_mark: |                    |                    | :heavy_check_mark: | 0 -> 3 || EP32_PICO       | :heavy_check_mark: |                    | :heavy_check_mark: |                    | 0 -> 3 |
| ESP32_LILYGO    | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |                    | 0 -> 3 |

## WROOM_32
Default version which supports all ESP32 versions but doesn't support Bluetooth BLE due to memory constraints in the IRAM section caused by PSRAM fixes for version 1 chips.

## WROOM_32_BLE
Same as the WROOM32 but drops PSRAM support to include Bluetooth BLE

## WROOM_32_V3_BL
This version is specific to ESP32 V3 and includes all support including PSRAM and Bluetooth.

## ESP32_PICO
Specific to ESP32 Pico. Same as WROOM_32_BLE but with a direct serial link speed.

# ESP32_LILYGO
Specific to LILYGO and OLIMEX POE boards. Same as WROOM32_BLE but also includes Ethernet support.

