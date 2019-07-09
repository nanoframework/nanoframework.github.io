# How To Flash a target using a **.dfu file**

This is a guide on how to manually flash the firmware provided as DFU file using ST DFUSE tools.

## Introduction

To manually flash firmware using ST DFUSE tools, get a copy of [ST DFUSE tools](https://www.st.com/en/development-tools/stsw-stm32080.html).

1. Install the DFUSE tools.

1. Put your device in bootloader mode. This can be accomplished by pressing a certain combination of buttons. It depends on the particular hardware that you are using.

### Step one

- Start the STDFU Tester application.
- Select the "Protocol" tab.
- Press the "Create from Map" button.
- Select the "Erase" radio button option.
- Press the "Go" button.
- Wait for the erase process to complete.

### Step two

- Start the DFUSE Demo Application
- Locate the **.dfu file** located in the device firmware update .zip file.
  > Note: If the .dfu file does not exist in the .zip file. It can be created following the instructions [here](create-dfu-file.md).
- Click the "Choose" button then the "Update" button.
- Toggle the devices power.
