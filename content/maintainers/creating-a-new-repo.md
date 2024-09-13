# Procedure for creating a new repository

## About this document

This document describes the recipe to create a new GitHub repository. It's meant for class libraries.

## Introduction

The strict following of this procedure is required in order to maintain consistency and coherence throughout the repositories, along with taking advantage of the build tools, testing and publishing automation.
If in doubt please ask one of the senior team members.

## Creating the repository in GitHub

1. This is basically clicking the create new repository button in GitHub.
    Note: The class libraries repositories are usually named with the prefix "*nanoFramework*.*namespace*" most of the remaining repositories are "**nf**-*some-relevant-name-here*".
2. As we are following the [GitFlow branching model](https://nvie.com/posts/a-successful-git-branching-model/) two branches must be created: `main` and `develop`.
3. Make sure to create an empty readme.md to make it easier to fork and clone the new repo.

## Adjust the repository settings (part 1)

1. Go to the repository **Settings** and move into **Options**.
1. In the**Features** section disable Wikis, Issues and Projects.
1. On the **Pull Requests** section disable Allow merge commits. We prefer to have tidy merges on PRs without having to bother contributors to squash commits.
1. Also there, disable merge commits. We prefer a straight history line.
1. Another tweak there: at allow squash merging, set the default message to `Pull request title`.
1. Move into **Branches** and set `main` as the default branch.

## Setup Sonarcloud project

For class libraries projects a Sonarcloud project has to be setup in order to run and process the project analysis.

1. Sign-in to Sonarcloud and create a new project.
1. On the repository list choose the corresponding name.
1. Choose "previous code" as the metrics analysis for new code.
1. OK to leave the rest with their defaults.

## Setup Azure DevOps

1. Open a new browser window on which you are signed in to GitHub as `nfbot`.
1. On the repo Settings, navigate to "GitHub Apps".
1. Click "Configure" button for Azure Pipelines.
1. The next step will take you to the [Azure DevOps](https://dev.azure.com/nanoframework) website.
1. Click on "Create New Project".
1. Name the project following the GitHub repo name. Select **Public** for visibility option.
1. After the project is created a list with GitHub repositories shows. Select the repository that has been just created.
1. The next step asks for the Pipeline configuration. Choose "Starter Pipeline" to get the build running and allow configuring the pipeline. The next steps will show the minimal yaml.
1. Click on "Variables" and add the following ones.
1. Add `DiscordWebhook` with a value taken from the Azure webhook of the "build-monitor" channel in our Discord server. **Make sure** that the variable is set to `secret` by clicking on the appropriate option.
1. Add another variable `GitHubToken` with a value taken from the nfbot personal tokens in GitHub. **Make sure** that the variable is set to `secret` by clicking on the padlock icon.
1. Add another variable `NbgvParameters`, leave it empty and check "Let users override this value when running this pipeline".
1. Add another variable `StartReleaseCandidate`, set the content to `false` and check "Let users override this value when running this pipeline".
1. Add another variable `UPDATE_DEPENDENTS`, set the content to `false` and check "Let users override this value when running this pipeline".
1. Click the "Save" button on the Variables pop-up (it will take you back to the pipeline yaml).
1. Cline the "Save" button at the top right and go through the commit message.
1. Navigate back to the Pipeline, select it and click "Edit" (at the top right). Then click on the 3 vertical dots (again at the top right) and then "Triggers".
1. Make sure that the option to override YAML is **not** checked for "Continuous integration". Uncheck the same option for "Pull request validation" and check the "Make secrets available to builds of forks".
1. Unckeck "Shallow fetch" in YAML tab.
1. Click "Save" in the toolbar (NOT "Save & Queue").
1. Go to the `General Project` project and navigate to Project Settings - Service Connections.
1. Open each of the service connections there, click on the 3 vertical dots (again at the top right) and then "Security". Scroll down to "Project permissions", click on the + icon at the right hand side and select the newlly created project. This will add a permission to use this shared service connection.
1. Navigate to the `Library` section (under `Pipelines`) and click on the plus sign to add a new `Variable group` named `sign-client-credentials`.
1. Add the following variables, all set to secret, with the values comming from the .NET Foundation signing service. Variables are `SignClientId`, `SignClientSecret`, `SignKeyVaultCertificate`, `SignKeyVaultUrl` and `SignTenantId`. **Make sure** that all the variables are set to `secret` by clicking on the appropriate option.
1. Go back to the pipelines view and with the current pipeline selected, click on the ellipsis icon and then on "Status badge". Copy the markdown code that shows on the pop-up. This will be required to add the correct build badges in the repo readme in a moment.

## Prepare the initial commit

1. Fork the repo into your preferred GutHub account and clone it locally.
1. The best option is to copy/paste from an existing repo, so you're more efficient doing just that. Mind the name changes tough! Grab the following files:
    - .gitignore **(no changes required)**
    - azure-pipelines.yml
    - LICENSE.md **(no changes required)**
    - README.md
    - version.json
    - NuGet.Config
    - assets\readme.txt
    - assets\nf-logo.png
1. Open "azure-pipelines.yml"
    1. Rename the `nugetPackageName` variable with the new name (mind the nanoframework prefix).
    1. Rename the `repoName` variable with the repo name.
    1. Rename the `sourceFileName` parameter with the equivalent name. It's probably wise to wait for the first successful build of the class library and then get back here with the correct name for the assembly declaration source file.
    1. Rename the `sonarCloudProject` variable with the project key from the Sonarcloud project.
    1. If there are class libraries that depend on this one, copy the "update dependencies" job from CorLib "azure-pipelines.yml". If there aren't just skip this step.
1. Open "version.json" and set the **version** to the appropriate one. Make sure to follow our version number guidelines. In doubt please ask one of the senior team members.
1. Open "README.md"
    1. Rename the class library name occurrences with the new name.
    2. Rename the package name for the NuGet badges.
    3. Replace the build status badges with the ones that you've copied from Azure DevOps. They'll be the same until there is a second pipeline for the master branch.
1. Create a folder at the root level with the name of the new class library.
1. Add to the VS Solution the class library project. Again it's better to follow an existing one and ask in doubt.
    1. Make sure you are following the naming pattern.
    1. Make sure you copy the `key.snk` from the initial repo (or from the CorLib repo). **DO NOT** create a new one.
1. Rename, edit and adjust as required the "nuspec" files to create the NuGet packages.
1. Edit the "readme.txt" inside the `assets` folder and rename the repository name.
1. Still on"azure-pipelines.yml" **and only** if there are class libraries that depend on this one.
    1. Adjust the `repositoriesToUpdate` list with the repo names of the class libraries that depend on this new one.
1. Create the .github folder with the workflows directory and the github actions yaml files inside.
1. Open the yaml files of the github actions and adjust the solution name.

## Adjust the repository settings (part 2)

1. Go to the repository settings in GitHub and move into **Branches**.
1. Go to the rule for "develop" branch and change the following:
      - Enable "Require pull request reviews before merging"
      - Enable "Require status checks to pass before merging" with the options:
        - "Require branches to be up to date before merging"
        - "Status checks: nanoframework.**azure-devops-project-name**"
        - "Status checks: license/cla" (for main branch)

## Update the dependency upwards

As a minimum, the new class library depends on mscorlib. If that's the only dependency, edit the [`azure-pipelines.yml`](https://github.com/nanoframework/CoreLibrary/blob/main/azure-pipelines.yml) file there and add this new repo to the `repositoriesToUpdate` list.
Now, if it depends on others, you have to figure out which one of those is **at the end** of the dependency chain and add this new repo to **that** `azure-pipelines.yml` file. For example, `System.Device.Gpio` depends on `CoreLibrary` and `Runtime.Events` (which, in turn, depends on `CoreLibrary`). Updating it's dependencies has to the triggered at `Runtime.Events` not on `CoreLibrary` because of the chained dependency.

## Add the class library to the documentation project

If this class library has documentation that has to be published as part of nanoFramework documentation (which is most likely) it needs to be referenced in the documentation project.

1. Edit the documentation repo [`azure-pipelines.yml`](https://github.com/nanoframework/nanoframework.github.io/blob/pages-source/azure-pipelines.yml) and add entries for this new repo at steps: `clone`, `restore` and `build`. Just follow one of the others already there.
1. Edit the class library documentation [document](../architecture/class-libraries.md) and add an entry for the new class library in the appropriate table, following the pattern and format being used there.
