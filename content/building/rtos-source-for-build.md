# Building .NET **nanoFramework** firmware with local RTOS source vs RTOS source from repository

When building .NET **nanoFramework** firmware the developer has two options: either using a local path for the RTOS source code or downloading it from the official repository.
This document aims to give you an brief overview of the differences between these two so you can choose the option that best fits your use scenario.

## Source from official repository

When running CMake, if the parameter `-DRTOS_SOURCE_FOLDER` is not not specified CMake will connect to the respective official repository and will clone the source from there. The time for this operation to complete will mostly depend on the speed of your internet connection.

The RTOS will be cached within the build directory so the full download won't happen again unless the build directory is cleared. A check for any changes in the upstream repository it's performed whenever a build is run. If there are any, the changes will be downloaded and merged.

This option it's great for automated builds or when you don't have (or don't want) the repo cloned to your local storage device.

Another advantage is that you don't have to manage the updates to the local clone yourself.

An obvious disadvantage is that if the build folder is cleaned (required when switching between target boards) the 'cached' repo will be gone and a full download will occur when the project is next built.

## Source from local clone

When running CMake, if the parameter `-DRTOS_SOURCE_FOLDER="....."` is specified, a local clone located at the designated path will be used when the build occurs.
The only _timing penalty_ is the one necessary for CMake to copy the contents of the local RTOS repo to the build cache folder. This is a one time operation and it won't happen again unless the build folder is cleaned up.

This option is preferable when you have a local clone of the repo and you don't want to increase the build time with checks on the repo and downloading it or wish to target a different branch.

The downside is that you have to manage the update process for the RTOS repo yourself.

Another important aspect to consider is the branch or tag that you have to **to _manually_ checkout**. Not doing this is synonym of using the default branch that contains the development files and is not a stable version, which is probably not what you want to use.
So, make sure that you checkout the branch or tag matching the currently supported stable version. In doubt ask in the Discord channel.

Also here, if the build folder is cleaned the 'cached' repo will be gone.
