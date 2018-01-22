Get-ChildItem "./*.nfproj" -Recurse) |
Foreach-object {
    $OldName = $_.name; 
    $NewName = $_.name -replace 'nfproj','csproj'; 
    Rename-Item -Newname $NewName -Verbose;
}
