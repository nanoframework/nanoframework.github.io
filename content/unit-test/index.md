# .NET **nanoFramework** Unit Tests platform

nanoFramework offers a complete Unit Tests platform called `nanoFramework.TestPlatform`

## What is nanoFramework.TestPlatform

nanoFramework.TestPlatform is a Unit Test platform dedicated to .NET **nanoFramework**! It has all the benefits of what you're used to when using Microsoft Test platform for .NET or XUnit or any other!

The framework includes multiple elements that are including in a single NuGet!

- `nanoFramework.TestPlatform` which contains the attributes to decorate your code and the `Assert` classes to check that you're code is properly doing what's expected.
- `nanoFramework.UnitTestLauncher` which is the engine launching and managing the Unit Tests.
- `nanoFramework.TestAdapter` which is the Visual Studio Test platform adapter, allowing to have the test integration in Visual Studio.

The integration looks like that:

![test integration](../../images/test-integration-vs.jpg)

And the integration will point you up to your code for successful or failed tests:

![test integration failed](../../images/test-integration-vs-failed.jpg)

## Usage of nanoFramework.TestPlatform

Simply add the `nanoFramework.TestPlatform` NuGet to your project and you're good to go!

![test NuGet](../../images/test-nuget-test-framework.jpg)

Once you'll build your project, the tests will be automatically discovered:

![test discovered](../../images/test-discovered.jpg)

You can then run all the tests and you'll get the result:

![test success](../../images/test-success.jpg)

Some tests may be skipped, they will appear like this:

![test skipped](../../images/test-skipped.jpg)

## Creating a new Visual Studio NFUnitTest project

You can as well simply create a new Visual Studio NFUnitTest project that will already contains all the needed elements.

![test VS project](../../images/test-project-template.png)

## Detailed usage

You will find the [detailed usage](using-test-platform.md), [how to run the tests](running-tests.md) and the [constraints/limitations](constraints-limitations.md) of the platform in the other documents.

If you are interested into the architecture, please check out [this detailed page](../architecture/unit-test.md).
