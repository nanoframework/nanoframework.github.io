# Native tips & tricsk, generating stubs for a native project, NANOCLR macros, Arguments and return types

When you want to use native code and creating an associated managed code C# library, you should start by reading [this article](https://jsimoesblog.wordpress.com/2018/06/19/interop-in-net-nanoframework/). This article will give you all the steps to create your managed C# project, generate the stubs and have everything glued together.

Once this is done, you'll still have to understand couple of elements related to the `NANOCLR` macros and the arguments and type conversions.

## NANOCLR macros

Once you generate the stubs, you'll have functions that looks like:

```cpp
HRESULT Library_sys_dev_pwm_native_System_Device_Pwm_PwmChannel::NativeInit___VOID( CLR_RT_StackFrame &stack )
{
    NANOCLR_HEADER();

    NANOCLR_SET_AND_LEAVE(stack.NotImplementedStub());

    NANOCLR_NOCLEANUP();
}
```

Every native code that is surfaced with the managed C# code will be generated with pre setup `NANOCLR` macros. They call all be found in [`src\CLR\Include\nanoCLR_Interop.h`](https://github.com/nanoframework/nf-interpreter/blob/f5d026224116bd671f42d5c482701447b1bf6e70/src/CLR/Include/nanoCLR_Interop.h). With all the elements below, you will be able to understand how to best use them.

### NANOCLR_HEADER

The `NANOCLR_HEADER` is always present at the top of each generated function. It's purpose is ti create the `HRESULT hr` variable.

### NANOCLR_CLEANUP or NANOCLR_NOCLEANUP, LABEL or NOLABEL

the `CLEANUP` family includes 4 declinations and few more elements:

```cpp
#define NANOCLR_LEAVE()  goto nanoCLR_Cleanup // Note: this is a bit simplified version when Debug is not used
#define NANOCLR_RETURN() return hr

#define NANOCLR_CLEANUP()     hr = S_OK; nanoCLR_Cleanup:
#define NANOCLR_CLEANUP_END() NANOCLR_RETURN()
#define NANOCLR_NOCLEANUP()   NANOCLR_CLEANUP(); NANOCLR_CLEANUP_END()
#define NANOCLR_NOCLEANUP_NOLABEL() hr = S_OK; NANOCLR_RETURN()
```

So to demystify and understand which one to use, the `NANOCLR_NOCLEANUP_NOLABEL();` is equivalent to: `hr = S_OK; return hr;`. So if you don't have to clean anything, that your code is straight forward, that's the general case you can use.

Looking at the `NANOCLR_NOCLEANUP` one, you'll have something added in the equivalent, a label: `hr = S_OK; nanoCLR_Cleanup:; return hr;`. As you see the label has been added and looking at few more definition, the `NANOCLR_LEAVE` macro is `goto nanoCLR_Cleanup` meaning, anything that needs some check and may leave earlier than a straight forward way will need to have the label version used.

The variation with `CLEANUP_END` is here to just return hr, it's as well one that can be used when you have nothing to check. While the  `NANOCLR_CLEANUP` one sets the hr to ok and place the label. It can't be used alone, the `NANOCLR_LEAVE` will have to be used after.

### NANOCLR_SET_AND_LEAVE, NANOCLR_CHECK_HRESULT and NANOCLR_EXIT_ON_SUCCESS

Those `NANOCLR_CHECK_HRESULT` and `NANOCLR_EXIT_ON_SUCCESS` macros allow you to check if a call to a function or an expression has failed or succeeded and then, as we've seen previously, go to `nanoCLR_Cleanup`. This is used a lot when you are calling other similar function returning as well an `HRESULT`.

```cpp
#define NANOCLR_CHECK_HRESULT(expr)   { if(FAILED(hr = (expr))) NANOCLR_LEAVE(); }
#define NANOCLR_EXIT_ON_SUCCESS(expr) { if(SUCCEEDED(hr = (expr))) NANOCLR_LEAVE(); }
#define NANOCLR_SET_AND_LEAVE(expr)   { hr = (expr); NANOCLR_LEAVE(); }
```

The `NANOCLR_SET_AND_LEAVE` function will just set the `HRESULT` and go to `nanoCLR_Cleanup`.

You will find a detailed list of typical HRESULT in the [`src\CLR\Include\nf_errors_exceptions.h`](https://github.com/nanoframework/nf-interpreter/blob/f5d026224116bd671f42d5c482701447b1bf6e70/src/CLR/Include/nf_errors_exceptions.h) file. FAILED and SUCCEEDED are defined like this:

```cpp
#define SUCCEEDED(Status) ((HRESULT)(Status) >= 0)
#define FAILED(Status)    ((HRESULT)(Status)<0)
```

### NANOCLR_MSG_SET_AND_LEAVE and NANOCLR_MSG1_SET_AND_LEAVE

Those 2 macros are defined like this:

```cpp
#define NANOCLR_MSG_SET_AND_LEAVE(expr, msg)       { hr = (expr); NANOCLR_LEAVE(); }
#define NANOCLR_MSG1_SET_AND_LEAVE(expr, msg, arg) { hr = (expr); NANOCLR_LEAVE(); }
```

So they allow you to setup the return element and leave. Those are so far used only in the `src\CLR\Core\TypeSystem.cpp` file. That said, nothing prevent you to use them as well.

## CLR_RT_StackFrame &stack

At every call to one of those native functions, the stack is passed thru a structure called CLR_RT_StackFrame. The definition can be found in `src\CLR\Include\nanoCLR_Runtime.h`. It would be too long to go thru all the functions and properties. In this description we will focus only on few elements.

### If your function is in a static class

In, this case, the stack class that you'll get it's is the "static instance" of the C# class. The pointer to the class instance is only available for non static calls. The reason for this is that the execution engine adds a pointer to the class instance to the IL stack, when there is an instance of it.

### Getting and checking the stack in a non static class

The pattern to use is the following:

```cpp
CLR_RT_HeapBlock* pThis = stack.This();
FAULT_ON_NULL(pThis);
```

`FAULT_ON_NULL` is a macro similar to the onces presented in the previous section which will check of the stack is null or not. In case of null it will go to the `nanoCLR_Cleanup` label and set the `HRESULT` to a null fault.

The definition can be found in `src\CLR\Include\nanoCLR_Interop.h`.

```cpp
#define FAULT_ON_NULL(ptr)     if(!(ptr)) NANOCLR_SET_AND_LEAVE(CLR_E_NULL_REFERENCE)
#define FAULT_ON_NULL_ARG(ptr) if(!(ptr)) NANOCLR_SET_AND_LEAVE(CLR_E_ARGUMENT_NULL)
```

You can use those macro for arguments too. We will see this in one of the following section.

### Getting any exposed field from the stack

Once you've checked that the stack is valid, you can get a pointer to any of the class fields. Here is a typical example:

```cpp
int pinNumber = (int)(pThis[Library_sys_dev_pwm_native_System_Device_Pwm_PwmChannel::FIELD___pinNumber].NumericByRef().u4);
```

The stack is a `CLR_RT_HeapBlock`. This type is the core type that allows you get access to a Heap Block, which are the objects that are placed in the IL stack.

The pattern to use is the array one: `pthis[the_field_to_get]` where you have to make sure the field does exist. To avoid any issue, it is recommended to use the long names like `Library_sys_dev_pwm_native_System_Device_Pwm_PwmChannel::FIELD___pinNumber`. But if it's in the same class, you don't need the long naming, `pThis[FIELD___pinNumber]` will just work as well.

Then the `NumericByRef()` allows you to get a numerical number and `u4` to convert it as a `uint32`. For numerics, you have as well `NumericByRefConst()` allowing to convert as a constant. Then you have `u` for non signed, 1, 2, 4 and 8 for the number of bytes. `i` for signed, `r4` for `float` and `r8` for `double`.

> Pro tip: the generated function definition contains the types and the return type. Example: `NativeSetActiveDutyCyclePercentage___VOID__U4` is void as return and U4 so uint32 for the first argument. This is done on purpose to help managing the return type and arguments.

## Arg0, Arg1, ArgsN

Helpers functions available to access the arguments. We will look at this in this section.

### Static class

In a static class, the `stack.Arg0()` points the first Heap Block passed on the IL stack. As explained before, do **not** use `CLR_RT_HeapBlock* pThis = stack.This();` because that won't be a pointer to a class instance (again: this is a call to a static method, therefore there is no instance of the class).

### Non static class

In a non static class, `stack.Arg0()` is equivalent to `stack.This()`. The first parameter passed from the C# method can be accessed with Arg1() and the following ones with equivalent calls that have the same index as the parameter.

#### Dereferencing an array

As an example, this time, let's use a function with an array:

```cpp
HRESULT Library_sys_dev_spi_native_System_Device_Spi_SpiDevice::NativeTransfer___VOID__SZARRAY_U2__SZARRAY_U2__BOOLEAN(CLR_RT_StackFrame &stack)
```

In this function, the return type is void, it's a non static one, the first and third arguments are `SZARRAY`, the second and fourth `U2`.  Still in this example, you will access the first array like this:

```cpp
CLR_RT_HeapBlock_Array *writeBuffer;
uint8_t *writeData = NULL;
writeBuffer = stack.Arg1().DereferenceArray();
if (writeBuffer != NULL)
{
     writeData = (unsigned char *)writeBuffer->GetFirstElementUInt16();
    // Do something as it's not null
}
```

The `DereferenceArray()` array function will allow you to get an array and to get access to the first element (in this case it's a UInt16 array), you can use `GetFirstElementUInt16()`. Array have their own heap types: `CLR_RT_HeapBlock_Array`. As you can guess you have other Element functions for the various system types.

#### Dereferencing an object

Similar to the array, you can dereference an object, a class or a structure. You will then be able to access its fields. Let's use the `SpanByte` structure as an example.

```cpp
CLR_RT_HeapBlock *writeSpanByte;
CLR_RT_HeapBlock_Array *writeBuffer;
uint8_t *writeData = NULL;
int16_t writeSize = 0;
int16_t writeOffset = 0;
writeSpanByte = stack.Arg1().Dereference();
if (writeSpanByte != NULL)
{
    // get buffer
    writeBuffer = writeSpanByte[SpanByte::FIELD___array].DereferenceArray();
    if (writeBuffer != NULL)
    {
        // Get the write offset, only the elements defined by the span must be written, not the whole
        // array
        writeOffset = writeSpanByte[SpanByte::FIELD___start].NumericByRef().s4;

        // use the span length as write size, only the elements defined by the span must be written
        writeSize = writeSpanByte[SpanByte::FIELD___length].NumericByRef().s4;
        writeData = (unsigned char *)writeBuffer->GetElement(writeOffset);
    }
}
```

SpanByte contains internal fields which are a byte array, a start int32 and length int32 elements. Giving the start and length of the buffer to use. So the pattern is actually to get a reference on the SpanByte, check if not null, get an array reference on the array, check if not nul and you can then have the size of the array. The `GetElement()` function will point you in the element you need.

#### ArgN

You only have 8 defined Arg, when you need to access them further, you can use `ArgN(the_number_to_access)`.

> Note: it is recommended to move to a class or structure when you start getting too many arguments.

### Getting a string

The pattern to get a string from the stack is to use the function `RecoverString()` if will give you a string.

```cpp
const char* szText = stack.Arg1().RecoverString();
// You can well check if it's a valid non null string like any other heap element:
FAULT_ON_NULL(szText);
```

### Setting a result

You can setup a return result using the family functions `SetResult_`. System types are directly available like U1 or R4 or any other mentioned before. for example `stack.SetResult_U1(42)` will place 42 as the return value for a function returning a byte type.

`SetResult_Object` allows you to return any valid object, class or structure.

To return a string, `SetResult_String` is your best friend. Note that this function returns an `HRESULT` and should be checked.

### Functions with reference parameters and how to set them

It is possible to have a function that has reference parameters and to set them on the native side.

Here is an example with a static function but it does work as well with non static functions (you just need to start at Arg1 for the first parameter):

```chsarp
[MethodImpl(MethodImplOptions.InternalCall)]
private extern static void NativeGetVoltage(ref TouchHighVoltage touchHighVoltage, ref TouchLowVoltage touchLowVoltage, ref TouchHighVoltageAttenuation touchHighVoltageAttenuation);
```

And here is a full simple example on how to set the parameters back:

```cpp
HRESULT Library_nanoFramework_hardware_esp32_native_nanoFramework_Hardware_Esp32_Touch_TouchPad::NativeGetVoltage___STATIC__VOID__BYREF_nanoFrameworkHardwareEsp32TouchTouchHighVoltage__BYREF_nanoFrameworkHardwareEsp32TouchTouchLowVoltage__BYREF_nanoFrameworkHardwareEsp32TouchTouchHighVoltageAttenuation( CLR_RT_StackFrame &stack )
{
    NANOCLR_HEADER();

    touch_high_volt_t refh;
    touch_low_volt_t refl;
    touch_volt_atten_t atten;

    // Get the voltage    
    if (touch_pad_get_voltage(&refh, &refl, &atten) == ESP_OK)
    {
        CLR_RT_HeapBlock bhRefh;
        CLR_RT_HeapBlock bhRefl;
        CLR_RT_HeapBlock bhAtten;
        bhRefh.SetInteger(refh);
        NANOCLR_CHECK_HRESULT(bhRefh.StoreToReference(stack.Arg0(), 0));
        bhRefl.SetInteger(refl);
        NANOCLR_CHECK_HRESULT(bhRefl.StoreToReference(stack.Arg1(), 0));
        bhAtten.SetInteger(atten);
        NANOCLR_CHECK_HRESULT(bhAtten.StoreToReference(stack.Arg2(), 0));
    }
    else
    {
        NANOCLR_SET_AND_LEAVE(CLR_E_INVALID_OPERATION);
    }

    NANOCLR_NOCLEANUP();
}
```

The key element here is the first create a heap block `CLR_RT_HeapBlock bhRefh;`, then set the value `bhRefh.SetInteger(refh);` and finaly store it into the argument `NANOCLR_CHECK_HRESULT(bhRefh.StoreToReference(stack.Arg0(), 0));`.

Note that this is working as well with objects, arrays or string.

## Generating exceptions and other HAL elements

It's possible to generate various exceptions from the native side. And it's as well possible to access more of the HAL elements.

### Generating exceptions

This is straight forward, you can use `NANOCLR_SET_AND_LEAVE(THE_EXCEPTION)`. The list of exception is available in [this include file](https://github.com/nanoframework/nf-interpreter/blob/main/src/CLR/Include/nf_errors_exceptions.h).

You can use it like this:

```cpp
NANOCLR_HEADER();

// some code

if (somethingWrong)
{
    NANOCLR_SET_AND_LEAVE(CLR_E_INVALID_OPERATION);
}

// If somethingWrong, then the code here won't be executed. You'll go directly to the end

// This is where you'll arrive
NANOCLR_NOCLEANUP();
```

### Checking results of a function

You can check if the result of a HRESULT function is a success or not by using `NANOCLR_CHECK_HRESULT` and few others like `NANOCLR_EXIT_ON_SUCCESS`. All those macros are available and documented in [this include file](https://github.com/nanoframework/nf-interpreter/blob/main/src/CLR/Include/nanoCLR_Interop.h). They al require to use the same pattern like:

```cpp
NANOCLR_HEADER();

// some code

NANOCLR_CHECK_HRESULT(AnotherNativeFunctionOfHRESULT);

// If somethingWrong, then the code here won't be executed. You'll go directly to the end

// This is where you'll arrive
NANOCLR_NOCLEANUP();
```

## Access to callback before soft reboot

Do you need to clean resources before a soft reboot? Yes, then you're covered. The function `HAL_AddSoftRebootHandler(FeatureSoftRebootHandler);` if here for you!

The `FeatureSoftRebootHandler` is a simple `void FunctionName()` handler. Add this into your initialization function and you'll be sure to be called before a soft reboot.

## Checking object types on native side

There are quite a few occasions where you want to pass an interface object on the native side.
Something like:

```csharp
[MethodImpl(MethodImplOptions.InternalCall)]
private extern static void NativeStartFilter(IFilterSetting periodSetting);

// With a simple IFilterSetting interface and 2 classes implementing the interface
public interface IFilterSetting
{
}

public class Esp32FilterSetting : IFilterSetting
{
    // Some private fields you'll access on the native side
    private uint _period;
    // And some public ones
}

public class S2S3FilterSetting : IFilterSetting
{
    // Different field here
    private int _anotherField
    // And more public fields
}
```

On the native side, you'll get a generated function and structures, they'll look like this:

```cpp
// The function definition, very classic
HRESULT Lib_Name::NativeStartFilter___STATIC__VOID__nanoFrameworkHardwareEsp32TouchIFilterSetting(CLR_RT_StackFrame &stack)

struct Lib_Name_Esp32FilterSetting
{
    static const int FIELD___period = 1;

    //--//
};

struct Lib_Name_S2S3FilterSetting
{
    static const int FIELD___anotherField = 1;
  
    //--//
};
```

The question is how on the native side, you can check if `Esp32FilterSetting` has been passed or `S2S3FilterSetting`?

The following code snippet shows you how you how to achieve this:

```cpp
CLR_RT_TypeDescriptor typeParamType;
CLR_RT_HeapBlock *bhPeriodeSetting;

// Static function, argument 0 is the first argument
bhPeriodeSetting = stack.Arg0().Dereference();

// get type descriptor for parameter
NANOCLR_CHECK_HRESULT(typeParamType.InitializeFromObject(*bhPeriodeSetting));

CLR_RT_TypeDef_Index esp32FilteringTypeDef;
CLR_RT_TypeDescriptor esp32FilteringType;
CLR_RT_TypeDef_Index s2s3FilteringTypeDef;    
CLR_RT_TypeDescriptor s2s3FilteringType;

// init types to compare with bhPeriodeSetting parameter
// You need the full namespace here
g_CLR_RT_TypeSystem.FindTypeDef("Esp32FilterSetting", "nanoFramework.Hardware.Esp32.Touch", esp32FilteringTypeDef);
esp32FilteringType.InitializeFromType(esp32FilteringTypeDef);

// You need the full namespace here
g_CLR_RT_TypeSystem.FindTypeDef("S2S3FilterSetting", "nanoFramework.Hardware.Esp32.Touch", s2s3FilteringTypeDef);
s2s3FilteringType.InitializeFromType(s2s3FilteringTypeDef);


// sanity check for parameter type
if (!CLR_RT_ExecutionEngine::IsInstanceOf(typeParamType, esp32FilteringType, false))
{
    // We have an Esp32FilterSetting
    // Implement your logic with this class
}
else if (!CLR_RT_ExecutionEngine::IsInstanceOf(typeParamType, s2s3FilteringType, false))
{
    // We have a S2S3FilterSetting
    // Implement your logic with this class
}
else
{
    // It's not what we expect!
    NANOCLR_SET_AND_LEAVE(CLR_E_INVALID_PARAMETER);
}
```

This does allow complex scenarios where you can differentiate the native execution. It does allow other scenarios where the hardware matters and you have a generic class but specific hardware settings. It's now open to your imagination!
