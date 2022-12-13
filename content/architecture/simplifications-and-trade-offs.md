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

Because of the underlying complexity and memory usage, multidimensional arrays are not supported. Only [jagged arrays](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/arrays/jagged-arrays). At the end of the day, these are pretty much equivalent, so if you need multidimensional arrays, you just need to adapt your code to what's available.

## String.Format and numeric.ToString Functions

.Net **nanoFramework** supports a subset of the [Standard numeric format strings](https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings) (D/F/G/N/X) and [Composite formatting](https://docs.microsoft.com/en-us/dotnet/standard/base-types/composite-formatting) (left and right alignment). It does NOT support any of the [Custom numeric format strings](https://docs.microsoft.com/en-us/dotnet/standard/base-types/custom-numeric-format-strings). Strings in **nanoFramework** are all constrained to UTF-8, so there are limits to the characters that can be displayed. The following format specifiers are supported:

| Specifier | Examples |
| --------- | ------- |
| [D-Decimal](https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings#DFormatString) | [Decimal unit test output](string-format-examples.md#d-decimal) |
| [F-Fixed-point](https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings#FFormatString) | [Fixed-point unit test output](string-format-examples.md#f-fixed-point) |
| [G-General](https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings#GFormatString) | [General unit test output](string-format-examples.md#g-general) |
| [N-Number](https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings#NFormatString) | [Number unit test output](string-format-examples.md#n-number) |
| [X-Hexadecimal](https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings#XFormatString) | [Hexadecimal unit test output](string-format-examples.md#x-hexadecimal) |

## Generics

.NET nanoFramework doesn't support generics. We are actively working on it! (You can track the progress by following [this](https://github.com/nanoframework/Home/issues/782) GitHub issue)
This is something that can easily go unnoticed as there are already some classes in mscorlib to support this. And, for the vast majority of the code, there will be no compiler error.
