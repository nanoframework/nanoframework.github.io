# Working with Visual Studio extension


## I have a Solution with several class library projects that are referenced in the application project. After a few debug sessions VS complains that it can't access one of them because the file is locked by another process.

This occurs because the debugger or de deployment provider have locked that DLL on a previous debug session.
To prevent this from happening, you have to open the "Configuration Manager" dialog for the Solution and un-check the "Deploy" option for all projects _except_ the executable. 
To remove the lock on that file open a PowerShell console and execute the following command, being NNNN the process number that shows at the very end of the VS message:
`Stop-Process -id NNNNN`.


## When I build a project/solutions it fails with an error `NFMDP: Error 0x81010009`. What is this?

This happens when you are using a C# feature that is not currently supported by nanoFramework. The most common cases are generics or a complicated Linq expression. 
There is currently no way to point you exactly where the issue is. The best suggestion is to build often so you can spot this as early as possible. It can also help if you comment the code that you've added recently and start uncomment as you run the build. This way you'll have a general guidance on where the root cause could be.

## When deploying an application I get a message like `Couldn't find a valid native assembly required by...` complaining that it can't find a native assembly. What can I do to fix this?

This occurs when you are deploying a project that is referencing one (or more) libraries for which the target image doesn't have support or are of a different version.
Make sure you have your NuGet updated and that the target device is flashed with the appropriate image.
It could be that you are referencing preview versions of the NuGet packages but the target device is flashed with an older stable image and is "behind".

## I'm having issues with NuGet package manager complaining that it can't resolve dependencies for a package.

This is occurring because you're referencing a preview NuGet package that is published only on nanoFramework MyGet feed. The same can occor if the package is referencing another package that its only available there.
If working with preview packages, make sure that you register nanoFramework MyGet feed by adding the package source in Visual Studio. Follow our blog post with instructions [here](https://nanoframework.net/2018/05/16/setup-visual-studio-to-access-preview-versions-feed/).
