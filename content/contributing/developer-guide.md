# Developer Guideline

We're working on it! Stay tuned! Raise PR and that will help us finding good recommendations.

Till then here follows some unsorted tips.

## How to call native code from managed code

Assuming you want to call from nanoframework's mscorlib (source can be found in lib-CoreLibrary repository) C# code (e.g. System.Number class) some implementation you would like to place in it's nanoCLR (source in nf-interpreter repository) C++ code. Follow steps below:

1. Build the nf-CoreLibrary solution without making any changes.
2. Copy the ```nanoFramework.CoreLibrary\bin\Debug\Stubs``` folder somewhere for later use.
3. Declare your C++ function in your C# class:

```
[MethodImpl(MethodImplOptions.InternalCall)]
private static extern String FormatNative(
   Object value,
   bool isInteger,
   String format,
   String numberDecimalSeparator,
   String negativeSign,
   String numberGroupSeparator,
   int[] numberGroupSizes);
```

2. Add code which calls the function above as you wish.
3. Build the solution.
4. Compare the ```nanoFramework.CoreLibrary\bin\Debug\Stubs``` folder's actual state with the saved one. The files which should have changed:
- ```corlib_native.cpp```
- ```corlib_native.h```
- your class's C++ counterpart, ```corlib_native_System_Number.cpp``` in the my example
5. Apply the changes you found to same files under ```nf-interpreter/src/CLR/CorLib```. DO NOT overwrite the files there! The files under nf-interpreter may have additional declarations, etc. Copy over the diff meaningfully!
6. You will find that a stub for the function you declared above will be generated with this signature:

```
HRESULT Library_corlib_native_System_Number::
    FormatNative___STATIC__STRING__OBJECT__BOOLEAN__STRING__STRING__STRING__STRING__SZARRAY_I4(CLR_RT_StackFrame &stack)
```

7. Now you can implement your function.


