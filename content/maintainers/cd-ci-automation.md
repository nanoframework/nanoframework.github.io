# CD & CI automation

## About this document

This document describes the CD-CI automation by means of Azure Pipelines and GitHub action.

## Commands that nfbot understands

nfbot reacts to commands passed on PR comments for any repository.
Only members of the organization have permission to send these commands.
On successful execution of a command, nfbot reacts to the comment with a 👍 for a correct execution or 🚀 if successfully launched an async operation. If case there is an error or problem with the execution it will react with 😕. If the expected conditions aren't meet the reaction is 👀.

The command syntax is: `@nfbot comand <argument(s)>`.

Available commands:

| Command | Argument | Description |
|:---|:---|:---|
| updatedependents | - | Update the libraries that depend on this library |
| updatedependencies | - | Check if there are updated versions of the referenced libraries and update if needed |
| updatedependencies all| - | Launch a global check for updated versions of the referenced libraries and update if needed in **all** class libraries |
| startrelease | - | Kick a release candidate workflow for this library. Will fail if there are preview dependencies for the library. |
| runpipeline | *branch* | Runs the Azure Pipeline for the mentioned branch. If no branch is mentioned runs it for the default branch. |
