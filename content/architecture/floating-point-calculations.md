# Floating-point calculations

## About this document

This document describes the specificities and available implementations of System.Math class library in .NET **nanoFramework**.

## Available APIs and floating-point implementations

The .NET System.Math APIs are available with `double` parameters. No sweat for the CPUs where the code usually runs.
When we move to embedded systems that's a totally different story.

A few more details to properly set context:

- [`double` type](https://docs.microsoft.com/en-us/dotnet/api/system.double): represents a double-precision 64-bit number with values ranging from negative 1.79769313486232e308 to positive 1.79769313486232e308. Precision ~15-17 digits. Size 8 bytes.
- [`float` type](https://docs.microsoft.com/en-us/dotnet/api/system.single): represents a single-precision 32-bit number with values ranging from negative 3.402823e38 to positive 3.402823e38. Precision ~6-9 digits. Size 4 bytes.
- Comparison of [floating-point numeric types](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/floating-point-numeric-types).

There are all sorts of variants and combinations on how to deal with FP and DP in the embedded world. From hardware support on the CPU to libraries that perform those calculations at the expense of more code and execution speed. .NET **nanoFramework** targets 32-bit MCUs, therefore support for 64-bits calculations requires extra code and processing.

Adding to the above, the extra precision provided by the `double` type is seldom required on typical embedded application use cases.

Considering all this and the ongoing quest to save flash space we've decided to provide two *flavours* for the System.Math API: the standard one with `double` type parameters and the alternative, lightweight one, with `float` type parameters.

This has zero impact on API and code reuse as both coexist. The only difference is on the firmware image. There is a build option (`DP_FLOATINGPOINT`) to build the image with DP floating point, when that extra precision is required.

A `NotImplementedException` will be throw when there is no native support for an API. The remedy is to call the API with the *other* parameter type.

```(csharp)
// this is OK when running on a image that has DP floating point support
Math.Pow(1.01580092094650000000000000, 0.19029495718363400000000000000);

// this is the correct usage when running on a image WITHOUT support for DP floating point
Math.Pow(1.0158009209465f, 0.190294957183634f);
```
