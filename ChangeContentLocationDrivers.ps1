Get-CMDriver | ForEach-Object{
    #Drivers

    Write-Output $_.LocalizedDisplayName

    #$Driver = Get-CMDriver -Name $_.LocalizedDisplayName

    $oldPath = $_.ContentSourcePath

    [string]$newPath = $oldPath.Replace("\\oldUNCPath\","\\newUNCPath\")

    Set-CMDriver -Name $_.LocalizedDisplayName -DriverSource $newPath
    Write-Output $oldPath
    Write-Output $newPath
} 

#Driver Packages
Get-CMDriverPackage | ForEach-Object{

    #$DriverPackage = Get-CMDriverPackage -Name "VMWare-All"

    $oldPkgPath = $_.PkgSourcePath

    [string]$newPkgPath = $oldPkgPath.Replace("\\oldUNCPath\","\\newUNCPath\")

    Set-CMDriverPackage -Name $_.Name -DriverPackageSource $newPkgPath

}