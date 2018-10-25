Get-ChildItem -Filter "*.nfproj" -Recurse | Rename-Item -NewName { $_.name -replace 'nfproj','csproj' }
