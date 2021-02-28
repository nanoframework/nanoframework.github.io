# Developer Guideline

We're working on it! Stay tuned! Raise PR and that will help us finding good recommendations.

Till then here follows some unsorted tips.
Neither are a full reference but they give some clue where to look next.

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

## How to handle in C++ parameter values received from C# call

Lets see the example method discussed in (#How-to-call-native-code-from-managed-code) tip. The generated (by lib-CoreLibrary solution build, where you declared your needs as an ```extern``` function) C++ stub will have a ```CLR_RT_StackFrame &stack``` parameter.
The values can be accessed as follows:

### ```object value```

```
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

```
// get value
bool isInteger;
isInteger = (bool)stack.Arg1().NumericByRef().u1;
```

### ```String format```

```
// get value
char *format;
format = (char *)stack.Arg2().RecoverString();
```

### ```int[] numberGroupSizes```

```
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

```
char * ret;
// ... assign value to ret ...

// use helper methods to set return value
NANOCLR_SET_AND_LEAVE(stack.SetResult_String(ret));
```

## Returning with an Exception

```
// see other CLR_E_* defined values
NANOCLR_SET_AND_LEAVE(CLR_E_FAIL);
```

Not sure on differences, but there is a ```NotImplementedStub``` helper on ```CLR_RT_StackFrame &stack``` parameter may be used too:

```
NANOCLR_SET_AND_LEAVE(stack.NotImplementedStub());
```

# Example managed-native development cycle

This is just a suggestion I found helpful for me during development of a feature crossing the managed-native border.
It saved me some time.

1. Write you managed code which requires native code support (see (#How-to-call-native-code-from-managed-code)) but DO NOT declare native part as an ```extern``` method. Just declare it as a "normal" private method. Add some simple implementation what supports the actual development state of your managed code, like return a constant what the currently implemented managed feature would expect from native call. Finish your managed coding agains this stub. You can either write tests for your code too because you have an "emulated" native behaviour. No need to leave the managed code development environment meanwhile.
2. Replace the stub with the correct ```extern``` declaration. Rebuild solution to get the appropriate corlib changes as described in (#How-to-call-native-code-from-managed-code).
3. Switch to native code development environment.
4. Add minimal implementation to the ```extern``` counterpart C++ function: just extract parameters from their CLR form to C++ form (see (#How to handle in C++ parameter values received from C# call)). The goal is: convert the managed-call-specific things into native C++. Forward call with the extracted parameters to a private func with same logical signature. Now you have a "clean" C++ function without any CLR specific parameter handling logic.
5. [Debug once](../building/build-esp32.md#debugging-nanoclr-without-special-hardware). Check that your "clean" C++ func receives all the parameters appropriatelly from managed call.
6. Implement the body of "clean" C++ function. At this moment you are not depending on managed call so you can write anywhere and with any development method, using tests to call your function without any need to setup extensive CLR objects just to test the code you are just developing. E.g. you can write and debug your code on https://www.onlinegdb.com/.
