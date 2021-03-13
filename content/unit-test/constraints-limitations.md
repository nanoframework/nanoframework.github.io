# Constraints and limitation of nanoFramework.TestPlatform

There are currently few limitations on the framework, the mains ones are so far:

- The assembly name containing all your tests has to be `NFUnitTest`. It's a limitation we're working on to remove. You can have as many classes and have as many test projects as you want. You just so far, need to have the assembly being named `NFUnitTest`. The Unit Test project template has this setup so, if start from the template, you don't have to change anything.
- The built elements for the test assembly has to be in the sub folders of the `nfproj` project. Typically `/directory_where_nfproj/bin/Debug/your.dll`. So do not adjust the default settings, they'll work perfectly for our use cases.
- The nanoCLR Win32 host has some limitations like networking, we're trying to add as many features as possible.
