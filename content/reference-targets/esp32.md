# Espressif ESP32 Series

These are the main images: 

- ESP32_REV1 that _fits_ all ESP32 boards carrying an ESP32 chip with PSRAM support, like the ESP32-DevKitC, ESP32-WROOM and ESP32-WROVER. You can check the non-exhaustive module and chip list [here](https://products.espressif.com/#/product-selector?names=&filter={%22Products%22:[%22Module%22,%22SoC%22],%22Series%22:[%22ESP32%22]}).
- ESP_WROVER_KIT specific for the ESP WROVER KIT. This one includes the UI features and driver for the ILI9341.
- ESP32_PICO that _fits_ all ESP32 boards carrying an ESP32 without PSRAM, like the ESP32_PICO and M5Stack ATOM.  You can check the non-exhaustive module and chip list [here](https://products.espressif.com/#/product-selector?names=&filter={%22Products%22:[%22Module%22,%22SoC%22],%22Series%22:[%22ESP32%22]}).
- ESP32_REV3 that _fits_ all ESP32 boards carrying an ESP32 chip **revision 3** with PSRAM support. You can check the non-exhaustive module and chip list [here](https://products.espressif.com/#/product-selector?names=&filter={%22Products%22:[%22Module%22,%22SoC%22],%22Series%22:[%22ESP32%22]}). 

> NOTE: Revision 3 chips are the most recent ones. (nanoff reports the revision of the chip right after connecting to the device). An image built for revision 1 wil run perfectly on a revision 3 chip. The other way around won't work.

Al other images are built out of those 2 core images. Variants then exist with or without BLE, with or without screens.

We do have a specific case is the ESP32-WROVER-KIT that include UI features (driver is ILI9341).

![esp32-devkitc](../../images/reference-targets/esp32-devkitc.jpg)

[ESP32-DevKitC Product page](https://www.espressif.com/en/products/hardware/esp32-devkitc/overview)

![esp32-wrover-kit](../../images/reference-targets/esp32-wrover-kit.jpg)

[ESP32-WROVER-KIT Product page](https://www.espressif.com/en/products/hardware/esp-wrover-kit/overview)

All M5Stack boards carry ESP32 chips. Some are revion 1, others 3, and others PICO. Please checkout the [official documentation](https://docs.m5stack.com/en/products?id=core) to understand which one is based on which chip.

![M5 Stack](../../images/reference-targets/M5Stack.jpg)

![M5 Stick](../../images/reference-targets/M5Stick.jpg)


## Firmware images (ready to deploy)

| Target | Stable | Preview |
|:-|---|---|
| ESP32_REV1 | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images/raw/ESP32_REV1/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images/packages/detail/raw/ESP32_REV1/latest/) | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images-dev/raw/ESP32_REV1/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images-dev/packages/detail/raw/ESP32_REV1/latest/) |
| ESP32_REV1_BLE | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images/raw/ESP32_REV1_BLE/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images/packages/detail/raw/ESP32_REV1_BLE/latest/) | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images-dev/raw/ESP32_REV1_BLE/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images-dev/packages/detail/raw/ESP32_REV1_BLE/latest/) |
| ESP32_REV3 | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images/raw/ESP32_REV3/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images/packages/detail/raw/ESP32_REV3/latest/) | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images-dev/raw/ESP32_REV3/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images-dev/packages/detail/raw/ESP32_REV3/latest/) |
| ESP32_REV3_BLE | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images/raw/ESP32_REV3_BLE/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images/packages/detail/raw/ESP32_REV3_BLE/latest/) | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images-dev/raw/ESP32_REV3_BLE/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images-dev/packages/detail/raw/ESP32_REV3_BLE/latest/) |
| ESP_WROVER_KIT | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images/raw/ESP_WROVER_KIT/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images/packages/detail/raw/ESP_WROVER_KIT/latest/) | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images-dev/raw/ESP_WROVER_KIT/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images-dev/packages/detail/raw/ESP_WROVER_KIT/latest/) |
| ESP32_PICO | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images/raw/ESP32_PICO/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images/packages/detail/raw/ESP32_PICO/latest/) | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images-dev/raw/ESP32_PICO/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images-dev/packages/detail/raw/ESP32_PICO/latest/) |
| ESP32_LILYGO | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images/raw/ESP32_LILYGO/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images/packages/detail/raw/ESP32_LILYGO/latest/) | [![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/net-nanoframework/nanoframework-images-dev/raw/ESP32_LILYGO/latest/x/?render=true)](https://cloudsmith.io/~net-nanoframework/repos/nanoframework-images-dev/packages/detail/raw/ESP32_LILYGO/latest/) |

> Note: You will find additional ESP32 based targets including screen driver names like:

- ESP32_REV1_ILI9342 (driver for M5Stack)
- ESP32_WROVER_KIT (this is the one containing the ILI9341 driver)
- ESP32_PICO_ST7735S (driver for M5Stick)
- ESP32_PICO_ST7789V (driver for M5Stick C Plus)
- ESP32_REV3_ILI9342
- ESP32_REV3_ILI9341

Check the details on the ESP32 pin-out available in nanoFramework [here](../esp32/esp32_pin_out.md).
