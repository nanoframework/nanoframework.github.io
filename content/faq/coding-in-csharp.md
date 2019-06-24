# Coding in C#

## Can I use auto-properties in classes?
No, you have to declare the backing fields.

## I have a Solution that targets both nanoFramework and standard .NET and would like to share/reuse code in both platforms. I know I can't reference assemblies from one into the other. How can I accomplish this?

Your best option is to use a shared project to hold the common code. Put there the classes that are to be used in both platforms. You can go all the way into this reusability by using compiler constants, compiler defines and even partial classes.
For a small example on this check the [ToString sample](https://github.com/nanoframework/Samples/tree/master/samples/ToStringTest) on our samples repo. It's using this technic to share code between a nanoFramework app and a .NET console app.

## I need to debug something in a class library how can I easily replace the NuGet reference with the real project?
This can be easily accomplished by using a handy Visual Studio extension called [NuGet Reference Switcher](https://marketplace.visualstudio.com/items?itemName=RicoSuter.NuGetReferenceSwitcherforVisualStudio2017). Add the class library project to your solution and using that tool _switch_ the NuGet package reference to the recently added project. After debugging you can switch back to the NuGet reference.
