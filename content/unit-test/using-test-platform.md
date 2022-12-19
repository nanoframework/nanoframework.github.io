# Using the nanoFramework.TestPlatform

The core component to prepare your test is `nanoFramework.TestPlatform`.

## The attributes

The classes and tests methods are recognized using attributes. You'll find the following ones:

- `[TestClass]`: this attribute is used on a class, without this attribute on the calls, the class won't be considered as a a valid Unit Test and the test methods inside will be ignored. You can have as many classes as you want with this attribute. Each class can then contain as many tests methods, setup and cleanup as you want.
- `[TestMethod]`: this attribute is used on any method where you'll have tests running inside. You can have as many methods with this attribute as you want.
- `[Setup]`: this attribute is used on any method. This test will be called first. While you technically have as many of those functions per class, it is recommended to only use 1 per class. Typical usage is to setup hardware you'll need to have running for all the tests methods.
- `[Cleanup]`: this attribute is used on any method. This test will be called last, after the all the tests methods. While you technically have as many of those functions per class, it is recommended to only use 1 per class.

## Attributes usage

Here is a typical example of how you can use the attributes:

```csharp
namespace nanoFramework.TestFramework.Test
{
    [TestClass]
    public class TestOfTest
    {
        [TestMethod]
        public void TestRaisesException()
        {
            Debug.WriteLine("Test will raise exception");
            Assert.Throws(typeof(Exception), ThrowMe);
        }

        private void ThrowMe()
        {
            throw new Exception("Test failed and it's a shame");
        }

        [Setup]
        public void RunSetup()
        {
            Debug.WriteLine("Setup");
        }

        [TestMethod]
        public void TestStringComparison()
        {
            Debug.WriteLine("Test string, Contains, EndsWith, StartWith");
            // Arrange
            string tocontains = "this text contains and end with contains";
            string startcontains = "contains start this text";
            string contains = "contains";
            string doesnotcontains = "this is totally something else";
            string empty = string.Empty;
            string stringnull = null;
            // Assert
            Assert.Contains(contains, tocontains);
            Assert.DoesNotContains(contains, doesnotcontains, "Your own error message");
            Assert.DoesNotContains(contains, empty);
            Assert.DoesNotContains(contains, stringnull);
            Assert.StartsWith(contains, startcontains);
            Assert.EndsWith(contains, tocontains);
        }

        [TestMethod]
        public void MethodWillSkippIfFloatingPointSupportNotOK()
        {
            var sysInfoFloat = SystemInfo.FloatingPointSupport;
            if ((sysInfoFloat != FloatingPoint.DoublePrecisionHardware) && (sysInfoFloat != FloatingPoint.DoublePrecisionSoftware))
            {
                Assert.SkipTest("Double floating point not supported, skipping the Assert.Double test");
            }

            double on42 = 42.1;
            double maxDouble = double.MaxValue;
            Assert.Equal(42.1, on42);
            Assert.Equal(double.MaxValue, maxDouble);
        }

        public void Nothing()
        {
            Debug.WriteLine("Nothing and should not be called");
        }

        [Cleanup]
        public void Cleanup()
        {
            Debug.WriteLine("Cleanup");
        }
    }
}
```

As you can see in this example, you just use the attributes to decorate the class and the functions.

Functions should be `void` type and take **no** argument at all.

The test *pass* if there is **no** exception happening in the function. If any exception happens in the function, it is considered as *failed*.

## Function visibility

All functions with attributes for testing must be `public void`, if you set them as private or internal, they won't be discovered.

## Asserting in the test functions

As for most of the famous .NET Unit Test platform, the concept of `Assert` is present as well in .NET **nanoFramework**. You can see in the previous example some of those `Assert` functions. They take one or two arguments and are straight forward to use.

If there is an issue in those Assert function, an exception is raised.

Note that all the `Assert` functions can pass a custom message. For example: `Assert.Equal(42, 43, "My custom message saying that 42 is not equal to 43");`

### Assert.Throws

This checks if a specific function will throw an exception. Usage:

```csharp
Assert.Throws(typeof(ExceptionTypeToCatch), AFunctionToCall);
```

Where:

- `ExceptionTypeToCatch` has to be a type of Exception. Typical example is to check if the function you're trying to call rases a `ArgumentException` for example.
- `AFunctionToCall` is an `Action`, so a function you can call to check if an exception is raised.

See the pattern in the previous example.

### Assert.True and Assert.False

Simply check if something is True or False

```csharp
bool boola = true;
Assert.True(boola);
```

### Assert.Equal and Asset.NotEqual

`Assert.Equal` is  collection of functions that takes all the native Value Types as well as Array and check if the elements in the array are equals (if value) or same object (for non value types).

```csharp
Assert.Equal(elementa, elementb);
```

Same behavior for `Assert.NotEqual` but checking that the 2 elements are not equal.

```csharp
Assert.NotEqual(elementa, elementb);
```

### Assert.Null and Assert.NotNull

Those functions check that an element is null or not null.

```csharp
object objnull = null;
object objnotnull = new object();
Assert.Null(objnull);
Assert.NotNull(objnotnull);
```

### Assert.IsType and Assert.IsNotType

Those functions allows to check that an element is a specific type or not a specific type.

```csharp
Type typea = typeof(int);
Type typeb = typeof(int);
Type typec = typeof(long);
Assert.IsType(typea, typeb);
Assert.IsNotType(typea, typec);
```

### Assert.Empty and Assert.NotEmpty

### Assert.Same and Assert.NotSame

Functions to check that objects are the same or different.

```csharp
object obja = new object();
object objb = new object();
Assert.NotSame(obja, objb);
objb = obja;
Assert.Same(obja, objb);
```

### Assert for String checking

A set of functions to help checking strings is available. They allow most of the common scenarios, checking that a string contains specific elements, start with, end with as well as not containing some elements.

```csharp
// Arrange
string tocontains = "this text contains and end with contains";
string startcontains = "contains start this text";
string contains = "contains";
string doesnotcontains = "this is totally something else";
string empty = string.Empty;
string stringnull = null;
// Assert
Assert.Contains(contains, tocontains);
Assert.DoesNotContains(contains, doesnotcontains);
Assert.DoesNotContains(contains, empty);
Assert.DoesNotContains(contains, stringnull);
Assert.StartsWith(contains, startcontains);
Assert.EndsWith(contains, tocontains);
```

### Outputting messages from the tests

It's possible to output messages from the Unit Tests using `OutputHelper.Write` and `OutputHelper.WriteLine`. These work exactly as `Debug.Write` and `Debug.WriteLine` so simple or formatted output is available.

```csharp
OutputHelper.WriteLine("This is a message from Unit Test XYZ!");
```

```csharp
OutputHelper.WriteLine($"This is another message from Unit Test XYZ, showing that {someVariable.Length} can be output too.");
```

### Skipping a test

You can skip a test by using `Assert.SkipTest`. You can place an explanation like this:

```csharp
Assert.SkipTest("Double floating point not supported, skipping the Assert.Double test");
```

**Important**: if you skip the `Setup` test, all the class `TestMethod` will be skipped as well. This is a convenient way to skip some specific hardware tests if the current hardware does not support them for example. This will allow to build different classes for different hardware for example and having only the right tests being executed.
