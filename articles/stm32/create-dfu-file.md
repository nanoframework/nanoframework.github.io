# How To Create a .dfu file

To manually flash firmware using ST DFUSE tools, get a copy of [ST DFUSE tools](https://www.st.com/en/development-tools/stsw-stm32080.html).

- Install the DFUSE tools
- Download the devices firmware update .zip file
- Repeat step 1 above

## Step one

- Locate the devices Device_BlockStorage.c file.
  - E.g. the Netduino 3 file is located [here](https://github.com/nanoframework/nf-interpreter/blob/develop/targets/CMSIS-OS/ChibiOS/NETDUINO3_WIFI/common/Device_BlockStorage.c).
- Find the BlockRegionInfo segment Start address and bytes per block.

Example:

```c
const BlockRegionInfo BlockRegions[] =

{
    {
        0x08000000,                         // start address for block region
        4,                                  // total number of blocks in this region
        0x4000,                             // total number of bytes per block
        ARRAYSIZE_CONST_EXPR(BlockRange1),
        BlockRange1,
    },
}
```

- Start the STDFU File Manager and select the "I want to generate a .dfu file ...." radio button.
- Select the "Muti BIN" button and select the nanoBooter.bin file from the firmware update .zip file. Enter the Start address from above into the "Address" textbox. Example: 8000000.
- Press the "Add to List" button.
- Next select the nanoCLR.bin file. Enter the Start address + bytes per block into the "Address" textbox. Example: 804000.
- Press the "Add to List" button.
- Press the "Generate" button.

## Step two

- Start the DFUSE Demo Application.
- Locate the .dfu file generated above.
- Click the "Choose" button then  the "Update" button.
- Toggle the devices power.
- That's all, we are done!
