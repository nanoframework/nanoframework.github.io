# Automatic Firmware Update

Automatic firmware updates are run as part of the build process initiated from the Visual Studio extension for nanoFramework. Please see the following blogpost: <https://www.nanoframework.net/automatic-firmware-updates/>

## What targets are supported by this automatic update?

Currently all STM32 targets for both officially supported reference targets and community targets found in our nf-Community-Targets repo.

## Can I use this if I have a custom board running my own firmware?

Not at this time. Currently this feature relies on the Cloudsmith API together with our repositories there, where we publish firmware packages. Supporting custom repos would require a standard way to access the packages storage and version querying. If you would like your board to be supported out of the box, feel free to add a PR to .NET nanoFramework nf-Community-Targets repo.

## How to prevent a board from updating if working on a custom firmware?

If you are running the build locally, the best approach would be to use the `BUILD_VERSION` property and sets it to a value which makes it "impossible" to find a better version e.g. `99.999.0.0`.
