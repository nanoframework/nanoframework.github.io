## Working with Visual Studio extension

* ### I have a Solution with several class library projects that are referenced in the application project and among each other. Despite deployment reports being successful my program is not running. What is happening?
    Unfortunately the deployment provider is not smart enough to resolve all the nested referenced assemblies in a Solution, so it's up to the developer to make sure **all** the referenced assemblies in any of the Solution projects are referenced in the _main_ application project (the one that has the `Program.Main()`).

