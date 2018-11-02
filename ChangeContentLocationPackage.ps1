#$thePackage = Get-CMPackage -Name "Adobe CS6 Serialization Fall 2014 Only"

Get-CMPackage | ForEach-Object{

    [string]$oldPackagePath = $_.PkgSourcePath

    [string]$newPackagePath = $oldPackagePath.Replace("\\oldUNCPath\","\\newUNCPath\")

    Set-CMPackage -Name $_.Name -Path $newPackagePath

}