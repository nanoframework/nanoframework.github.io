# Working with Visual Studio extension


## I have a Solution with several class library projects that are referenced in the application project. After a few debug sessions VS complains that it can't access one of them because the file is locked by another process.

This occurs because the debugger or de deployment provider have locked that DLL on a previous debug session.
To prevent this from happening, you have to open the "Configuration Manager" dialog for the Solution and un-check the "Deploy" option for all projects _except_ the executable. 
To remove the lock on that file open a PowerShell console and execute the following command, being NNNN the process number that shows at the very end of the VS message:
`Stop-Process -id NNNNN`.