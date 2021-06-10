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

## Multidimensional arrays

Because of the underlying complexity and memory usage, multidimensional arrays are not supported. Only [jagged arrays](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/arrays/jagged-arrays). At the end of the day, these are pretty much equivalent, so if you need multidimensional arrays, you just need to adapt your code to what's available.

## String.Format and numeric.ToString Functions
nanoFramework supports a subset of the [Standard numeric format strings](https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings). It does NOT support any of the [Custom numeric format strings](https://docs.microsoft.com/en-us/dotnet/standard/base-types/custom-numeric-format-strings).  The following format specifiers are supported:
|Specifier|Samples|
|---------|-------------|-------|
|[D-Decimal](https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings#DFormatString)|[Unit test output](.\string-format-examples.md#decimal)