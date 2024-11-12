$AllFolders = Get-ChildItem -Directory -Path "\\server01\Share1" -Recurse -Dept 4 -Force
$Results = @()
Foreach ($Folder in $AllFolders) {
    $Acl = Get-Acl -Path $Folder.FullName
    foreach ($Access in $acl.Access) {
        if ($Access.IdentityReference -notlike "CREATOR OWNER" -and $access.IdentityReference -notlike "NT AUTHORITY\SYSTEM") {
            $Properties = [ordered]@{'FolderName'=$Folder.FullName;'AD Group'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
            $Results += New-Object -TypeName PSObject -Property $Properties
        }
    }
}

$Results | Export-Csv -path "c:\TEMP Share1 FolderPermissions - $(Get-Date -format MMyy).csv" -Encoding UTF8
