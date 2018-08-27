# Coding in C# 


## Can I use auto-properties in classes?
No, you have to declare the backing fields.


## I have a Solution that targets both nanoFramework and standard .NET and would like to share/reuse code in both platforms. I know I can't reference assemblies from one into the other. How can I accomplish this?
Your best option is to use a shared project to hold the common code. Put there the classes that are to be used in both platforms. You can go all the way into this reusability by using compiler constants, compiler defines and even partial classes.
For a small example on this check the [ToString sample](https://github.com/nanoframework/Samples/tree/master/ToStringTest) on our samples repo. It's using this technic to share code between a nanoFramework app and a .NET console app.
