# In-field update for nanoFramework

*(proposal)*

In-field updates are a highly requested and high-value feature for any embedded system framework that aims to be embraced by the industry and maker community in general.

That is why this is a must-have for nanoFramework.

This document captures the vision for this and the specification for how it will work.

## Overview

A nanoFramework device can have its CLR image and/or the managed app updated.

The need to update the CLR arises from the fact that a new CLR image is made available because one (or more) class libraries or the CLR itself have been updated. Depending on the update extent and the versioning, it often requires that the managed application deployed on the target must be updated too.

The need to update the managed application arises from the fact that a new version of the application is available as part of the usual lifecycle: new features have been added, bugs fixed, or a new version of referenced library(ies) has/have been published.

The update service shall be part of the core features. The update service should be “baked” into the CLR image and run entirely in the background. This is opposed to the approach found in similar frameworks in which it must be controlled/managed by the C# application running on the target device. Pretty much as it happens with a Windows PC where the Windows Update service runs in the background and does its thing without requiring any intervention from users. nanoFramework update service is configurable on how it works and how updates are managed.

This background and automated approach brings along another advantage, which is removing the need to abstract the different ways that each platform uses to deal with firmware updates.

## Architecture

The firmware update is triggered at boot time. This is the approach that is common to all supported platforms and that makes more sense. Launching the update when the system has completed boot sequence, when the managed application is already running, can raise problems derived from the need to stop services, threads, dispose objects, stop the CLR execution, etc. Also, having to manage the update process from the app looks a bit counter-intuitive and makes the update dependent on the app that is going to be updated.

Preferably the update should be handled by the API, utility, or mechanism that is provided by each platform to deal with this operation.

There will be two types of update packages:

- Combined CLR and managed application
- Managed application only

The update packages can be delivered to target devices by any of the following channels:

- **Mass storage devices** — Any SD Card or USB stick that holds the update package.
- **Internal storage** — Like flash, EEPROM, FRAM storage chips accessible by SPI, QSPI, or even the MCU internal storage.
- **Network connections** — Anything is valid, as long as it can receive data. These are for the delivery of the update package, not updating the firmware “on-the-fly”. The update package is received as a whole or in chunks, stored in one of the available options in the device, and then the update process is kicked off following the appropriate workflow. Being able to update devices as the package is being received requires a more complex handling of the update procedure. It is something that is very convenient in some use-case scenarios and can be made available in the future.

In order to increase the robustness and reliability of the process, the update options and configurations are to be provided at build time.

The API available will be minimal: only the required methods/properties to query if an update package is available. There is no need to provide methods to start or commit the update, as those are part of the update workflow that is run at boot time.

## Platform specifics

### ESP32

This platform includes an update process called OTA (Over the Air Update). Basically, it requires two partitions on the device flash to store the application images and a third one to store data pertaining to the updates and the active partition. There is an API to manage the update process and the platform bootloader is responsible for switching the image to run.

### STM32

This platform includes several options to help firmware updates. There is DFU, dual boot partitions, boot from QSPI memory, and others. But none of those can fully manage the update process. Adding to this, not all of them are available in the various targets and series that we support. This imposes an extra burden on the feature implementation for the platform. Because of this, it probably will be the most challenging platform to implement.

### TI SimpleLink for CC3220

This platform includes an update process called OTA (Over the Air Update). The update partition file is stored in the flash storage and the booter takes care of managing the whole process. There is an API available to manage the update process.

## Implementation description

This is a high-level description of how the components work integrated in the CLR and how the update workflow progresses. It is grouped by the delivery mechanism followed by the platform implementation, if applicable.

### Mass storage devices

An update package will be a file with a specific name/extension saved in the drive root folder.

At boot time, that specific file is looked for. If found and deemed valid, its version is compared against the current image. If the file contains a more recent version, the update workflow starts; if not, the CLR is launched.

#### ESP32

A call to the OTA API starts the upgrade process, copying the new image content from the update package to the destination partition and finally committing the update.

#### STM32

The required flash sectors are erased, and the new content is flashed by copying the new image content from the update package. After this, a reboot is forced.

#### TI SimpleLink for CC3220

This platform currently does not support mass storage devices.

### Internal storage

To support this, the internal storage must be configured to use SPIFFS.

An update package will be a file with a specific name/extension stored in the SPIFFS drive.

At boot time, that specific file is looked for. If found and deemed valid, its version is compared against the current image. If the file contains a more recent version, the update workflow starts; if not, the CLR is launched.

#### ESP32

A call to the OTA API starts the upgrade process, copying the new image content from the update package to the destination partition and finally committing the update.

#### STM32

The required flash sectors are erased, and the new content is flashed by copying the new image content from the update package. After this, a reboot is forced.

#### TI SimpleLink for CC3220

Updating from locally stored files is currently not supported by this platform.

### Network connected devices

This process involves connecting to an “update server” where a file with version information is downloaded. If there is a newer version available, the update package is downloaded and stored locally, preferably on an internal storage device (for increased reliability).

After this step, the device is rebooted and the update process starts as described in the corresponding local-storage workflow.

#### ESP32

There will be a thread running that endlessly performs the described procedure of checking for a new version on the update server, at a configured interval.

#### STM32

There will be a thread running that endlessly performs the described procedure of checking for a new version on the update server, at a configured interval.

#### TI SimpleLink for CC3220

The prescribed (and only) OTA process of the platform is exactly this one: connect to an online content provider from where the update package is downloaded. The configuration observes a very specific format and options available in the product documentation. It involves creating an update package that is platform-specific.

## Typical usage scenarios

The following usage scenarios help explain how all the above works in practice.

### Stand-alone device with USB connector exposed

- The user carries a USB flash drive with the update package file.
- Plugs the USB flash drive.
- Hits the reset button.
- Target nano device boots.
- New image is installed.
- Target nano reboots itself with the new image.

### Stand-alone device with SD Card connector

Same as above, except the user puts the SD Card in the connector instead of the USB flash drive.

### Network connected device

- The CLR periodically checks the available version from an online service. This can be a proprietary server or a public CDN, for example.
- When a new version is available, the CLR downloads the update package and stores it locally on a storage device.
- After receiving the update package, it reboots itself.
- The new image is installed.
- The device reboots itself with the new image.

## FAQ

### How can my C# app tell if there is an update available?

The API will provide a method to query if there is an update package available. Upon return, if there is one, it will include information on the type and versions.

### What does it mean exactly that “an update package is available”?

It means that an update package is available in any of the storage options (USB, SD Card, or SPIFFS drive) and that it is ready to be deployed.

### I have a very specific use case that requires me to get the update package from a specific source in my C# app. Will this work?

Yes, as long as you store the update package on the local storage options (USB, SD Card, or SPIFFS drive) and respect the file name pattern, the update workflow will pick it up during boot and will do its magic.

### Is there an extra delay during boot because of the update?

Yes. The file system must be mounted, and the existence of an update package checked. If there is a package available, it must be opened and the update manifest parsed, and the version compared against the running image. All this incurs a time penalty during boot.

### Can my C# app abort an update?

No. If your C# app is running, that is because the update process is done and the CLR has been launched, either from an updated image or from the existing one.

### I have situations where the C# application is the same despite running on different hardware devices. Can the update system deal with this?

Yes. You can either have the updates checked from different endpoints or you can deal with the update distribution yourself in your C# app.

### How can my app know that an update has occurred?

You have to implement that yourself. The update service focus is on providing a way to update a device image, not exactly providing a history of updates. Keep in mind that our focus is embedded systems.
