# Working with Visual Studio extension

## I have a Solution with several class library projects that are referenced in the application project. After a few debug sessions VS complains that it can't access one of them because the file is locked by another process

This occurs because the debugger or de deployment provider have locked that DLL on a previous debug session.
To prevent this from happening, you have to open the "Configuration Manager" dialog for the Solution and un-check the "Deploy" option for all projects _except_ the executable.
To remove the lock on that file open a PowerShell console and execute the following command, being NNNN the process number that shows at the very end of the VS message:
`Stop-Process -id NNNNN`.

## When opening a Solution, Visual Studio complains about missing references and I see a bunch of red squiggles and there is no Intellisense

This can happen because Visual Studio is having issues resolving types from one or more referenced assemblies.
Start by restoring the NuGet packages by right clicking on the Solution (in Solution Explorer). Then rebuild.
If that doesn't work, you can try clean the solution and then close and open the Solution again.
In case that still doesn't work: close the solution and manually delete the `bin`, `obj` and `.vs` folders. Then open it again, restore the NuGet packages and rebuild. That should take care of it.

## When I build a project/solutions it fails with an error `NFMDP: Error 0x81010009`. What is this

This happens when you are using a C# feature that is not currently supported by nanoFramework. The most common cases are generics or a complicated Linq expression.
There is currently no way to point you exactly where the issue is. The best suggestion is to build often so you can spot this as early as possible. It can also help if you comment the code that you've added recently and start uncomment as you run the build. This way you'll have a general guidance on where the root cause could be.

## When deploying an application I get a message like `Couldn't find a valid native assembly required by...` complaining that it can't find a native assembly. What can I do to fix this

This occurs when you are deploying a project that is referencing one (or more) libraries for which the target image doesn't have support or are of a different version.
Make sure you have your NuGet updated and that the target device is flashed with the appropriate image.
It could be that you are referencing preview versions of the NuGet packages but the target device is flashed with an older stable image and is "behind".
For a detailed explanation please check [this blog post](https://www.nanoframework.net/nuget-assembly-and-native-versions/) with the details.

## I'm having issues with NuGet package manager complaining that it can't resolve dependencies for a package

This is occurring because you're probably referencing a preview version of a NuGet package that is published only on .NET **nanoFramework** development feed. The same can occur if the package is referencing another package that its only available there.
When working with preview packages, make sure that you register nanoFramework Azure DevOps NuGet feed by adding the package source in Visual Studio. Follow our blog post with instructions [here](https://nanoframework.net/setup-visual-studio-to-access-preview-versions-feed/).

## After starting a debug session it end abruptly with a message like `Error: Device stopped after type resolution failure`. What can I do to fix this

This happens when there is a problem with type resolution on the deployed application. Usually happens after one of these situations:

- The firmware image was updated and the deployment wasn't erased. The assemblies in the deployment area are outdated and the required types or versions can't be found on the new image. Fix: erase de deployment area and deploy a new version of the application.
- One or more NuGet packages where updated and there is a version mismatch between them. This is noticeable by Visual Studio adding an `app.config` file to one or more of the projects to use assembly binding redirect. This is not possible with .NET **nanoFramework**. Fix: erase the `app.config` and work the update of the NuGet packages. The best option is usually to update the one(s) that have more dependencies and the package manager will make sure to update all the other in a cascading manner. If this doesn't work the alternative is to uninstall the NuGet packages and start adding them back again.

## I need to revert the VS extension I have installed to an older version. How can I do that?

You can do that following these steps:

1. Uninstall the current version from the "Manage Extension" window in Visual Studio.
1. Go to the [Releases](https://github.com/nanoframework/nf-Visual-Studio-extension/releases) section in the Visual Studio extension repository.
1. Find the version that you're looking for and expand the 'Assets' listed in the release entry.
1. Download the '.vsix' package and start the install.

## I'm having issues installing the Visual Studio extension

- Our extension is maintained and kept up to date with the current version of VS2022 and VS2019. Generally only the latest version of Visual Studio is guaranteed to be supported. If you experience difficulties installing the extension, check that you are running the latest VS.NET version. If you need an older version for a specific VS version, you can download it from the [GitHub repository](https://github.com/nanoframework/nf-Visual-Studio-extension/releases).

## I want to exclude certain COM ports from being scanned by Device Explorer

1. Open the Settings dialog in Device Explorer (cog wheel icon).
1. Go to General tab.
1. Add to 'COM port exclusion list' the COM port(s) to exclude, separated by a semi-column, no spaces.
