# Simplifications and trade-offs in .NET **nanoFramework**

## About this document

This document describes the simplifications and trade-offs introduced in .NET **nanoFramework** when comparing it to the full framework.

## Enums

We are oversimplifying `enums`. They are special classes which basically contain fields which are constants.
ECMA-335 allows several simplifications that our CLR takes advantage of. That's made perfectly clear in the standard by this statement in II.14.3 "These restrictions allow a very efficient implementation of enums."

Since there is no real value in storing the value names and the constants they represent we choose not to do it. This saves an entry in the Fields table and the corresponding ones in the signatures table and also in the strings table (for the value name). At minimum, this would cost 8 + 2 + (n) bytes in the PE file. Mostly depending on the size of the string with the names.

Because of this, we don't have support for `Enum.GetNames()`, `Enum.GetValues()` and `Enum.IsDefined()`.
But we have `HasFlag()`!

Notes:

- These could be made available, at the expense of increasing the PE size.
- For `Enum.IsDefined()` you can always use a switch instruction in your code to create something similar depending on your use case.
- An enum value's ToString() will return the numerical value as a string, not the enum name as is the case for other platforms.

## Multidimensional arrays

Because of the underlying complexity and memory usage, multidimensional arrays are not supported. Only [jagged arrays](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/arrays/jagged-arrays). At the end of the day, these are pretty much equivalent, so if you need multidimensional arrays, you just need to adapt your code to what's available.

## String.Format and numeric.ToString Functions

.Net **nanoFramework** supports a subset of the [Standard numeric format strings](https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings) (D/F/G/N/X) and [Composite formatting](https://learn.microsoft.com/en-us/dotnet/standard/base-types/composite-formatting) (left and right alignment). It does NOT support any of the [Custom numeric format strings](https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-numeric-format-strings). Strings in **nanoFramework** are all constrained to UTF-8, so there are limits to the characters that can be displayed. The following format specifiers are supported:

| Specifier | Examples |
| --------- | ------- |
| [D-Decimal](https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings#decimal-format-specifier-d) | [Decimal unit test output](string-format-examples.md#d-decimal) |
| [F-Fixed-point](https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings#fixed-point-format-specifier-f) | [Fixed-point unit test output](string-format-examples.md#f-fixed-point) |
| [G-General](https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings#general-format-specifier-g) | [General unit test output](string-format-examples.md#g-general) |
| [N-Number](https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings#numeric-format-specifier-n) | [Number unit test output](string-format-examples.md#n-number) |
| [X-Hexadecimal](https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings#hexadecimal-format-specifier-x) | [Hexadecimal unit test output](string-format-examples.md#x-hexadecimal) |

## Generics

Generics support is now available as a **public preview**! Check out [README-GENERICS.md](https://github.com/nanoframework/nf-interpreter/blob/main/README-GENERICS.md) in the `nf-interpreter` repo for details on how to update your firmware, Visual Studio extension and NuGet packages to try it out, as well as the current known limitations.

We'd love for you to give it a spin and share your experience (bugs, rough edges, missing library support, anything) in the `#generics-public-preview` channel on our [Discord server](https://discord.gg/gCyBu8VB5H). Your feedback is what will help get this over the line for a stable release!
