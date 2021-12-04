# C/C++ Coding Style

For C/C++ files (*.c,*.cpp and *.h), we use clang-format (version 3.10) to ensure code styling.
The rules and config files are included in the nf-interpreter repository.

## Using Visual Studio Code

If you are using Visual Studio Code we suggest that you install the [Clang-Format extension](https://marketplace.visualstudio.com/items?itemName=xaver.clang-format).
To have this extension working you need to have the clang-format.exe installed on your system.

LLVM.org doesn't provide a separate installer for this tool so follows a quick and dirty way of getting it.

1. Install the Clang-Format extension.
1. Install the LLVM package from [here](https://github.com/llvm/llvm-project/releases/).
1. Take note of the path where you choose to install it.
1. Back in VS Code, open the settings and adjust the entry for `clang-format.executable` with the path to the executable. The new setting file will have a new entry with something similar to the following:

```json
"clang-format.executable" : "C:/Program Files/LLVM/bin/clang-format.exe"
```

You might have something slightly different in your setup.
Just remember the following: add that setting, the path that you've copied before, change it to have forward slashes and add the **clang-format.exe** at the end.

After following the above steps successfully you can now right click on any C, C++ or H file and hit 'Format Document'. The VS Code extension will take care that the document is properly formatted according to the coding style guidelines.

When you have the extension installed, you can request VS Code to automatically format a file on save by adding the following to your vscode settings.json file:

```json
{
    "editor.formatOnSave": true
}
```

>**WARNING**: you'll need to avoid automatic formating on 3rd party files (both .h and .c and .cpp) as the formatting can introduce many changes that add no value and make it very difficult to subsequintly compare the file with the orginal or with a template file when the external 3rd party software is updated.

You can turn clang auto format 'off' and 'on' around code you don't what reformatted.

Typically at the top of the file below the Copright notice turn off clang-formating with:

```c
// clang-format off
```

and  at the end of the file remember to turn it back on with:

```c
// clang-format on
```

## Using Visual Studio

If you are using Visual Studio we suggest that you install the [ClangFormat extension](https://marketplace.visualstudio.com/items?itemName=LLVMExtensions.ClangFormat).
