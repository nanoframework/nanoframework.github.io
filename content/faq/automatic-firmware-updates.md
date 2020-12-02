# Automatic Firmware Update


## What targets are supported by this automatic update?

Currently all STM32 targets for both reference and community targets.


## Can I use this if I have a custom board running my own firmware?

Not at this time. Currently this feature relies on Bintray API and repository where we publish the firmware packages. Supporting custom repos would require a standard way to access the packages storage and version querying. 


## How to prevent a board for which I'm working on a custom firmware to be updated?

If you are running the build locally, the best approach would be to use a version which makes it "impossible" to find a better version. Something like 99.999.0.0.
