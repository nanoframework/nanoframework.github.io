# Container maintenance

## Adjusting the Dockerfile images

The Dockerfile source images are located in `.devcontainer/sources`. Whenever you need to adjust something, please check the following:

* [ ] when you adjust a version for a cloned repository, please check **all** the Dockerfile
* [ ] in `.github/workflows` change the version for the generated image
* [ ] in the `.devcontainer` adjust the version of the corresponding Dockerfile

Example:

* [X] when you adjust a version for a cloned repository, please check **all** the Dockerfile
  * You change the file `targets/TI-SimpleLin/CMakeLists.txt`and adjust the version in `set(TI_SL_CC13x2_26x2_SDK_TAG "4.40.04.04" CACHE INTERNAL "TI CC13x2_26x2 SDK tag")`
  * You need to adjust this version as well in `.devcontainer/sources/Dockerfile.All` and adjust it here `git clone --branch 4.40.04.04 https://github.com/nanoframework/SimpleLink_CC13x2_26x2_SDK.git --depth 1 ./sources/SimpleLinkCC13 \`
  * You need to adjust this version as well in `.devcontainer/sources/Dockerfile.TI` and adjust it here `git clone --branch 4.40.04.04 https://github.com/nanoframework/SimpleLink_CC13x2_26x2_SDK.git --depth 1 ./sources/SimpleLinkCC13 \`
  * Be aware that some cloned repositories are present in almost all the files. So make sure you adjust all of them.
* [X] in `.github/workflows` change the version for the generated image
  * change the version of the container in `all.yaml` by increasing the minor version (major if this is a real major change), for example if it was 1.5 to `GCR_VERSION: v1.6`
  * change the version of the container in `ti.yaml` by increasing the minor version (major if this is a real major change), for example if it was 1.2 to `GCR_VERSION: v1.3`
  * Be aware that versions of the different containers can be different depending on the changes made
* [X] in the `.devcontainer` adjust the version of the corresponding Dockerfile
  * Change the version accordingly in `Dockerfile.All` to `FROM ghcr.io/ellerbach/dev-container-all:v1.6`
  * Change the version accordingly in `Dockerfile.TI` to `FROM ghcr.io/ellerbach/dev-container-all:v1.6`

## Publishing a new package

Buy default a new package has a private visibility. You will need to adjust the visibility of the potential new dev containers by:

1. Go to <https://github.com/orgs/nanoframework/packages>
1. Select the package
1. Click `Connect Repository`
1. Select `nf-interpreter`
1. Click `View all tagged versions`
1. Click `Options`
1. Adjust the visibility to public
1. Check as well `Inherit access from source repository`
