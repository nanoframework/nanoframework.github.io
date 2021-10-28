# Developer Guidelines

We're working on it! Stay tuned! Raise PR and that will help us finding good recommendations.

Until then, here follows some unsorted tips.
These are not a full reference, but they give some clues on where to look next.

## Quick note about compatibility between managed and native parts

There is an interface mechanism between the managed libraries and the firmware. This interface is structured around the methods decorated with the `MethodImpl(MethodImplOptions.InternalCall)` attribute. During the build of a managed library a checksum value generated taking into account the methods name, parameters and return types. That checksum, is used to characterize the library interface and it's stored in stub files.
Changes can happen at both ends without any compatibility issues, as long as the interface does change.

More details about checksum value can be found in [NativeMethodsChecksum](../architecture/pe-file/AssemblyHeader.md#nativemethodschecksum) `AssemblyHeader` field description.

More details about whole versioning can be found in [NuGet, assembly and native versions](https://www.nanoframework.net/nuget-assembly-and-native-versions/) blog post.

## How to call native code from managed code

Assuming you want to call from nanoframework's mscorlib (source can be found in CoreLibrary repository) C# code (e.g. System.Number class) some implementation you would like to place in it's nanoCLR (source in nf-interpreter repository) C++ code. Follow steps below:

1. Build the nf-CoreLibrary solution without making any changes.
1. Copy these folders somewhere for later use:
   - ```nanoFramework.CoreLibrary\bin\Debug\Stubs```
   - ```nanoFramework.CoreLibrary.NoReflection\bin\Debug\Stubs```
1. Declare your C++ function in your C# class:

   ```csharp
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

1. Add code which calls the function above as you wish.
1. If you change the assembly signature (via adding or modifying an ```extern``` function) you should bump the assembly version in the ```AssemblyInfo.cs``` file:

   ```csharp
   [assembly: AssemblyNativeVersion("100.5.0.5")]
   ```

1. Build the solution.
1. Compare the ```nanoFramework.CoreLibrary\bin\Debug\Stubs``` folder's actual state with the saved one. The files which should have changed:
   - ```corlib_native.cpp```
   - ```corlib_native.h```
   - your class's C++ counterpart, ```corlib_native_System_Number.cpp``` in the example

   Do the same with ```nanoFramework.CoreLibrary.NoReflection\bin\Debug\Stubs``` too.
1. Apply the changes you found to the same files under ```nf-interpreter/src/CLR/CorLib```.

   **DO NOT** overwrite the files there! The files under nf-interpreter may have additional declarations, etc.
   Open the file and look for ```#if (NANOCLR_REFLECTION ==``` lines. There could be more of them.
   Copy over the diff meaningfully:
   - changes from the ```nanoFramework.CoreLibrary\bin\Debug\Stubs``` are going inside the ```NANOCLR_REFLECTION == TRUE``` blocks
   - changes from the ```nanoFramework.CoreLibrary.NoReflection\bin\Debug\Stubs``` are going inside the ```NANOCLR_REFLECTION == FALSE``` blocks.
1. You will find that a stub for the function you declared above will be generated with this signature:

   ```cpp
   HRESULT Library_corlib_native_System_Number::
       FormatNative___STATIC__STRING__OBJECT__BOOLEAN__STRING__STRING__STRING__STRING__SZARRAY_I4(CLR_RT_StackFrame &stack)
   ```

1. Now you can implement your function.

## How to handle the C++ parameter values received from a C# call

Lets see the example method discussed in the (#How-to-call-native-code-from-managed-code) tip. The generated (by lib-CoreLibrary solution build, where you declared your needs as an ```extern``` function) C++ stub will have a ```CLR_RT_StackFrame &stack``` parameter.
The values can be accessed as follows:

### ```object value```

```cpp
// get ref to value container
CLR_RT_HeapBlock *value;
value = &(stack.Arg0());

// perform unboxing operation if necessary
CLR_RT_TypeDescriptor desc;
NANOCLR_CHECK_HRESULT(desc.InitializeFromObject(*value));
NANOCLR_CHECK_HRESULT(value->PerformUnboxing(desc.m_handlerCls));

// get the CLR_DataType of the value in container, like DATATYPE_U1 for a Byte or DATATYPE_R8 for Double
CLR_DataType dataType = value->DataType();

// retrieving the real value depends on dataType above
int32_t int32Value = value->NumericByRef().s4;
```

### ```bool isInteger```

```cpp
// get value
bool isInteger;
isInteger = (bool)stack.Arg1().NumericByRef().u1;
```

### ```String format```

```cpp
// get value
char *format;
format = (char *)stack.Arg2().RecoverString();
```

### ```int[] numberGroupSizes```

```cpp
// get ref to value container
CLR_RT_HeapBlock_Array *numberGroupSizes;
numberGroupSizes = stack.Arg6().DereferenceArray();

// get number of elements
CLR_UINT32 numOfElements = numberGroupSizes->m_numOfElements;

// get the 5th element
// cast necessary, because GetElement declared as CLR_INT8*, 
// but the C# code call placed items of Int32 type into array.
int the5thEelement = *((CLR_INT32 *)numberGroupSizes->GetElement(5));
```

## Returning from C++ function for C# code

Values should be returned via the ```CLR_RT_StackFrame &stack``` parameter.

### String

```cpp
char * ret;
// ... assign value to ret ...

// use helper methods to set return value
NANOCLR_SET_AND_LEAVE(stack.SetResult_String(ret));
```

## Returning with an Exception

```cpp
// see other CLR_E_* defined values
NANOCLR_SET_AND_LEAVE(CLR_E_FAIL);
```

Not sure on the differences, but there is a ```NotImplementedStub``` helper on ```CLR_RT_StackFrame &stack``` parameter may be used too:

```cpp
NANOCLR_SET_AND_LEAVE(stack.NotImplementedStub());
```

## Example managed-native development cycle

The managed-native border crossing development cycle could have significant time penalty.
Without any shortcuts the required steps are:

1. The native code changes should be compiled
2. The native code changes should be downloaded to the device
3. The managed code should be compiled
4. The managed code should be downloaded to the device
5. The code should be executed.

So two builds, two downloads required and two development environments involved.

Below you can find a suggestion which can be used in cases when the physical device's capabilities (lik GPIO ports, etc.) not affected by the development, only it's execution of the nanoCLR (like the number ToString() implementation) required.
It saved me a lot of time.

1. Write you managed code which requires native code support (see (#How-to-call-native-code-from-managed-code)) but DO NOT declare native part as an ```extern``` method. Just declare it as a "normal" private method. Add some simple implementation what supports the actual development state of your managed code, like return a constant what the currently implemented managed feature would expect from native call. Finish your managed coding agains this stub. You can either write tests for your code too because you have an "emulated" native behaviour. No need to leave the managed code development environment meanwhile.
2. Replace the stub with the correct ```extern``` declaration. Rebuild solution to get the appropriate corlib changes as described in (#How-to-call-native-code-from-managed-code).
3. Switch to native code development environment.
4. Add minimal implementation to the ```extern``` counterpart C++ function: just extract parameters from their CLR form to C++ form (see (#How to handle in C++ parameter values received from C# call)). The goal is: convert the managed-call-specific things into native C++. Forward call with the extracted parameters to a private func with same logical signature. Now you have a "clean" C++ function without any CLR specific parameter handling logic.
5. [Debug once](../building/build-esp32.md#debugging-nanoclr-without-special-hardware). Check that your "clean" C++ func receives all the parameters appropriatelly from managed call.
6. Implement the body of "clean" C++ function. At this moment you are not depending on managed call so you can write anywhere and with any development method, using tests to call your function without any need to setup extensive CLR objects just to test the code you are just developing. E.g. you can write and debug your code on <https://www.onlinegdb.com/>.
