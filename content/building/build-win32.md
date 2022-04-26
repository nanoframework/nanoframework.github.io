# Building .NET nanoFramework - WIN32

⚠️ NOTE about the need to build .NET **nanoFramework** firmware ⚠️

You only need to build it if you plan to debug the CLR, interpreter, execution engine, drivers, add new targets or add new features at native level.
If your goal is to code in C# you just have to flash your MCU with the appropriate firmware image using [nanoff](https://github.com/nanoframework/nanoFirmwareFlasher).
There are available ready to flash firmware images for several targets, please check the [Home](https://github.com/nanoframework/Home#firmware-for-reference-boards) repository.

The WIN32 version is meant to be used for high level debugging, feature testing and Unit Testing for other projects.
It's a VC++ solution which can be build using Visual Studio.

## Building

1. Clone the `nf-interpreter` repository.
1. Open `targets\win32\nanoCLR.sln` solution with VS.
1. Build the solution.
1. Make sure `nanoCLR` is the start project.
1. Use either directly from the command line or starting a debug session.
1. To load assemblies use the following syntax:

    ```console
    -load <path-to-the-PE-file-1> -load <path-to-the-PE-file-2> ...
    ```
