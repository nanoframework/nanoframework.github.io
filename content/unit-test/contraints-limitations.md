# Constraints and limitation of nanoFramework.TestPlatform

There are currently few limitations on the framework, the mains ones are so far:

- The Unit Test integration will only run on Windows, you can technically run them in the device and you'll get in the debug window the result but it won't be integrated. See the section below.
- The assembly name containing all your tests has to be `Test`. It's a limitation we're working on to remove. You can have as many classes and have as many test projects as you want. You just so far, need to have the assembly being named `Test`.
- The built elements for the test assembly has to be in the sub folders of the `nfproj` project. Typically `/directory_where_nfproj/bin/Debug/your.dll`. So do not adjust the default settings, they'll work perfectly for our use cases.
- The current running time for the functions is not implemented on the Windows test platform. You'll get the running time if the tests are run on a real hardware. It's a limitation that we're working on to fix.

## Running the Unit Test on a device

This scenario is absolutely possible but you won't get the integration with Visual Studio and the results integrated.

You will have to deploy on your device, the following elements:

- `mscorlib`
- `nanoFramework.UnitTestLauncher`, if you recompile it and deploy it, it **must** be in `Debug` mode
- `nanoFramework.TestPlatform`
- Your own test assembly names `Test`, it can be compiled either in `Debug` or `Release`

You'll have to run the tests, you have to catch the results from the debug window. Results will look like that:

```text
Ready.
Hello from nanoFrmaework UnitTestLauncher!
Setup
Test passed: RunSetup, 20
Test will raise exception
    ++++ Exception System.Exception - 0x00000000 (1) ++++
    ++++ Message: Test failed and it's a shame
    ++++ nanoFramework.TestFramework.Test.TestOfTest::ThrowMe [IP: 0007] ++++
    ++++ nanoFramework.TestFramework.Test.TestOfTest::TestRaisesException [IP: 001b] ++++
    ++++ System.Reflection.MethodBase::Invoke [IP: 0000] ++++
    ++++ nanoFramework.TestFramework.UnitTestLauncher::RunTest [IP: 004d] ++++
    ++++ nanoFramework.TestFramework.UnitTestLauncher::Main [IP: 0081] ++++
Test passed: TestRaisesException, 50
Test will check that all the Equal are actually equal
Test passed: TestCheckAllEqual, 100
Test will check that all the NotEqual are actually equal
Test passed: TestCheckAllNotEqual, 152
Test null, not null, types
Test passed: TestNullEmpty, 42
Test string, Contains, EndsWith, StartWith
Test passed: TestStringComparison, 53
    ++++ Exception System.Exception - 0x00000000 (1) ++++
    ++++ Message: Test failed and it's a shame
    ++++ nanoFramework.TestFramework.Test.TestOfTest::ThrowMe [IP: 0007] ++++
    ++++ nanoFramework.TestFramework.Test.TestOfTest::TestRaisesException [IP: 001b] ++++
    ++++ System.Reflection.MethodBase::Invoke [IP: 0000] ++++
    ++++ nanoFramework.TestFramework.UnitTestLauncher::RunTest [IP: 004d] ++++
    ++++ nanoFramework.TestFramework.UnitTestLauncher::Main [IP: 0081] ++++
Test failed: SuperTest, This test was intended to fail!
Cleanup
Test passed: Cleanup, 55
Done.
Exiting.
```

From the debug output, you can extract successful tests and failed test. The format is the following:

- `Test passed: MethodName, #` where `MethodName` is the method name and `#` the number of ticks that has passed during the test.
- `Test failed: MethodName, Exception message` where `MethodName` is the method name and then you have the exception message.

The rest of the text is what is output from your own code and the exception raised plus the nanoFramework own logging like `Ready.`, `Done.` and `Exiting.`. You can exploit those output.

**Important**: Please make sure you're **not** using the same pattern as `Test passed` and `Test failed` to log your own information. This may break the test platform.

It is plan to properly integrate Unit Test on real hardware as well in the future.
