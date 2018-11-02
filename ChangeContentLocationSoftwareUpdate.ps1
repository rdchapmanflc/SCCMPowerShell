#$SoftwareUpdate = Get-CMSoftwareUpdateDeploymentPackage -Name "201503-Patches"

Get-CMSoftwareUpdateDeploymentPackage | ForEach-Object{


    [string]$oldSoftwareUpdatePath = $_.PkgSourcePath

    [string]$newSoftwareUpdatePath = $oldSoftwareUpdatePath.Replace("\\oldUNCPath\","\\newUNCPath\")

    Set-CMSoftwareUpdateDeploymentPackage -Name $_.Name -Path $newSoftwareUpdatePath
}