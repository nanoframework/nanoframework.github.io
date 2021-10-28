# Building .NET nanoFramework - WIN32

The WIN32 version meant to be used for high level debugging, feature testing and Unit Testing for other projects.
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
