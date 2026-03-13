# In-field Update for nanoFramework

In-field updates are a highly requested and high-value feature for any embedded system framework that aims to be embraced by the industry and maker community in general. That is why this is a must-have for nanoFramework.

This document captures the design for in-field update (IFU) and the specification for how it will work.

## Overview

A nanoFramework device can have its CLR image and/or the managed app updated.

The need to update the CLR arises from the fact that a new CLR image is made available because one (or more) class libraries or the CLR itself have been updated. Depending on the update extent and the versioning, it often requires that the managed application deployed on the target must be updated too.

The need to update the managed application arises from the fact that a new version of the application is available as part of the usual lifecycle: new features have been added, bugs fixed, or a new version of referenced library(ies) has/have been published.

The update service shall be part of the core features. The update service should be "baked" into the CLR image and run entirely in the background. This is opposed to the approach found in similar frameworks in which it must be controlled/managed by the C# application running on the target device. Pretty much as it happens with a Windows PC where the Windows Update service runs in the background and does its thing without requiring any intervention from users. nanoFramework update service is configurable on how it works and how updates are managed.

This background and automated approach brings along another advantage, which is removing the need to abstract the different ways that each platform uses to deal with firmware updates.

## Architecture

### Bootloader: MCUboot

The IFU architecture is built on [MCUboot](https://mcuboot.com/), a mature, secure bootloader for 32-bit microcontrollers. MCUboot provides:

- Image validation and authentication
- Pending/test/permanent upgrade flows
- Rollback/revert behavior
- A standard slot-based upgrade model

MCUboot entirely replaces the existing nanoBooter. This removes the need to re-implement complex boot/update state handling in-house and gives the project a stronger technical baseline for IFU.

### Device management: mcumgr / SMP

[mcumgr](https://docs.zephyrproject.org/latest/services/device_mgmt/mcumgr.html) replaces the role currently served by nanoBooter as the device-side management and communication layer. Today, nanoBooter handles the Wire Protocol interactions used to flash firmware and deploy managed applications. Under the new architecture, mcumgr takes over this responsibility, acting as the management transport and command layer between host tooling and the device.

mcumgr implements the Simple Management Protocol (SMP), a lightweight request/response protocol designed for device management on constrained embedded systems. It provides a standardized command interface for image management operations — including upload, slot inspection, activation, and confirmation — as well as system-level commands such as reset and status queries. This replaces the proprietary Wire Protocol currently used by nanoBooter with an open, well-documented protocol that is already supported by a mature ecosystem of host-side libraries and tools.

mcumgr provides a CLI with serial transport to the devices. Supported transports include:

- **UART** — Standard serial connection.
- **USB CDC ACM** — Virtual serial port over USB.
- **BLE** — Bluetooth Low Energy (on capable targets).

nanoFramework-specific extensions to the mcumgr command set will be required, especially around:

- **Managed application image/deployment handling** — mcumgr's standard image management commands are designed for firmware slots and do not natively cover the separate managed deployment region used by nanoFramework.
- **Deployment region management** — Support for the upload, inspection, and lifecycle control of .NET assemblies independently from firmware images.
- **Workflow integration** — Ensuring the transition from nanoBooter to mcumgr is transparent to end users working through nanoff, Visual Studio, or VS Code.

### Update image storage

The standard approach, following MCUboot's official repositories, is to use external **(Q)SPI flash** to store update images. This is the primary and recommended storage mechanism.

nanoFramework extends this to support additional storage options:

- **(Q)SPI flash** — External flash chips accessible via SPI or QSPI. This is the standard MCUboot approach and the default storage for update images.
- **SD Card** — Update images stored on an SD Card, enabling offline update scenarios.
- **USB Mass Storage Device (MSD)** — Update images stored on a USB flash drive, enabling field updates by non-technical personnel.

### Update workflow

MCUboot uses a slot-based model: the running firmware lives in the **primary slot** and a candidate update image is placed in the **secondary slot** (typically on external (Q)SPI flash). On every boot, MCUboot inspects the secondary slot. If a valid, pending update image is found, MCUboot performs the swap — copying the new image into the primary slot (and optionally preserving the old image for rollback) — then boots the new firmware. If no update is pending, MCUboot simply validates the primary slot image and boots it directly, with minimal overhead.

This boot-time approach is intentional: attempting an update after the CLR and the managed application are already running would require stopping services, threads, disposing objects, and halting the CLR — adding complexity and failure modes. By running entirely before the CLR starts, MCUboot keeps the update process independent of the application being updated.

There will be two types of update packages:

- Combined CLR and managed application
- Managed application only

The update packages can be delivered to target devices by any of the following channels:

- **External (Q)SPI flash** — The standard MCUboot approach. Update images are written to the external flash and MCUboot handles the swap at boot.
- **SD Card** — An update package file stored on an SD Card. At boot time, the file is read and written to the appropriate MCUboot slot for processing.
- **USB Mass Storage Device** — Same workflow as SD Card, using a USB flash drive as the source.
- **Network connections** — The update package is received over the network (as a whole or in chunks), stored in external (Q)SPI flash, and then the device is rebooted to trigger the MCUboot upgrade workflow.
- **mcumgr serial transport** — Update images can be uploaded directly to the device via mcumgr's CLI over UART, USB CDC ACM, or BLE. mcumgr handles writing the image to the appropriate slot.

In order to increase the robustness and reliability of the process, the update options and configurations are to be provided at build time.

The managed C# API available will be minimal: only the required methods/properties to query if an update package is available. There is no need to provide methods to start or commit the update, as those are part of the MCUboot update workflow that is run at boot time.

## Platform specifics

### ESP32

MCUboot already has an Espressif port. Although the ESP32 platform includes a native OTA (Over the Air Update) mechanism, MCUboot is the preferred path for nanoFramework IFU as it provides a more complete and consistent solution. MCUboot on ESP32 still relies on the underlying IDF mechanisms where appropriate.

Integration work is expected to align with ESP-IDF assumptions and the specific HAL/platform dependencies of the Espressif MCUboot port.

### STM32

MCUboot integration and porting work is expected for the nanoFramework combinations in use, including RTOS-specific work for FreeRTOS and ChibiOS targets. The STM32 platform offers several options (DFU, dual boot partitions, boot from QSPI memory), but MCUboot provides a unified and consistent approach across the various targets and series that nanoFramework supports.

### TI SimpleLink for CC3220

This platform includes its own OTA (Over the Air Update) mechanism with support for cloud-based update flows (referencing providers such as GitHub and Dropbox). Because the vendor-native OTA path is well-integrated for this platform, it should remain the preferred option rather than forcing MCUboot.

## Host-side tooling

The existing nanoFirmwareFlasher (nanoff) flow must be refactored to support the MCUboot + mcumgr stack.

Today, nanoff already handles flashing firmware and deployment images and integrates multiple platform-specific tools. The IFU work will evolve this into a reusable library-first component, then expose it through:

- **nanoff** — Command-line interface.
- **Visual Studio integration** — Seamless IDE experience.
- **VS Code integration** — Seamless IDE experience.

This will also allow use in internal/company-specific automation tools and CLIs, similar to what is happening today with the nanoff library.

This is especially important for ESP32, where current flows rely on esptool assumptions that will be replaced in the new architecture.

## Update retrieval (connected IFU)

In addition to bootloader integration, a separate component is required to retrieve update artifacts for network-connected devices (both firmware/CLR payloads and managed application payloads).

This component should be designed with a provider abstraction, avoiding tight coupling to proprietary platform features where reasonable. Candidate initial providers include:

- GitHub
- Azure Storage
- Azure Device Update
- Dropbox

The goal is a generic and extensible API so the same IFU architecture can be used with different content delivery providers.

## Typical usage scenarios

The following usage scenarios help explain how all the above works in practice.

### Stand-alone device with USB connector exposed

- The user carries a USB flash drive with the update package file.
- Plugs the USB flash drive.
- Hits the reset button.
- Target nano device boots; MCUboot detects the update image.
- New image is validated and installed by MCUboot.
- Target nano reboots itself with the new image.

### Stand-alone device with SD Card connector

Same as above, except the user puts the SD Card in the connector instead of the USB flash drive.

### Device with external (Q)SPI flash

- An update image is written to the external (Q)SPI flash (via mcumgr, network download, or other means).
- The device is rebooted.
- MCUboot validates the image and performs the swap/upgrade.
- The device boots with the new image.

### Update via mcumgr CLI

- The user connects to the device via serial (UART or USB CDC ACM) or BLE.
- Using the mcumgr CLI, the update image is uploaded to the device.
- The device is reset (via mcumgr command or manually).
- MCUboot validates and installs the new image.
- The device boots with the new image.

### Network connected device

- A background component periodically checks the available version from an online service (e.g., GitHub, Azure Storage, Dropbox, or a proprietary server).
- When a new version is available, the update package is downloaded and stored to external (Q)SPI flash.
- After receiving the update package, the device reboots.
- MCUboot validates and installs the new image.
- The device reboots with the new image.

## FAQ

### How can my C# app tell if there is an update available?

The API will provide a method to query if there is an update package available. Upon return, if there is one, it will include information on the type and versions.

### What does it mean exactly that "an update package is available"?

It means that an update image is available in the MCUboot secondary slot (external (Q)SPI flash, or staged from SD Card/USB MSD) and is ready to be deployed on the next boot.

### I have a very specific use case that requires me to get the update package from a specific source in my C# app. Will this work?

Yes, as long as you store the update package in the MCUboot secondary slot (or on a supported storage option such as SD Card or USB MSD where the boot process will stage it), the MCUboot update workflow will pick it up during boot and handle the upgrade.

### Is there an extra delay during boot because of the update?

Yes. MCUboot must validate the image in the secondary slot and, if an update is pending, perform the swap/copy operation. The duration depends on the image size and the flash speed. When no update is pending, the overhead is minimal (image validation of the primary slot only).

### Can my C# app abort an update?

No. If your C# app is running, that is because MCUboot has already completed the boot process and the CLR has been launched, either from an updated image or from the existing one. MCUboot does support a "test" upgrade mode where the new image must be confirmed by the application; if not confirmed, MCUboot will revert to the previous image on the next reboot.

### What happens if an update fails or the new image is broken?

MCUboot provides built-in rollback/revert behavior. If the new image fails validation or is not confirmed (in test mode), MCUboot will automatically revert to the previous working image on the next boot.

### I have situations where the C# application is the same despite running on different hardware devices. Can the update system deal with this?

Yes. You can either have the updates checked from different endpoints or you can deal with the update distribution yourself in your C# app.

### How can my app know that an update has occurred?

Yes. MCUboot stores version and swap-state information in the image header and trailer of the primary slot. The CLR will read this at startup and expose it through the managed API, so the C# application can query the current image version and whether the image was recently swapped in (and whether it has been confirmed).

### What replaces nanoBooter?

MCUboot replaces nanoBooter as the bootloader, and mcumgr replaces the Wire Protocol as the device management and communication layer. The mcumgr CLI provides serial transport (UART, USB CDC ACM, BLE) for image upload, slot management, and device control.

## Revision history

| Revision | Date | Summary |
|----------|------|---------|
| 1 | 2026-03-13 | Replaced nanoBooter with MCUboot + mcumgr architecture; added (Q)SPI flash, SD Card, and USB MSD storage options; added host-side tooling and connected IFU retrieval sections; updated FAQ. |
| 0 | 2020-10-19 | Initial design proposal. |
