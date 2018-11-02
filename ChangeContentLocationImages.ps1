Get-CMOperatingSystemImage | ForEach-Object{
    
    Write-Output $_.Name

    #Images
    $Image = Get-CMOperatingSystemImage -Name $_.Name

    [string]$oldImagePath = $_.PkgSourcePath

    [string]$newImagePath = $oldImagePath.Replace("\\oldUNCPath\","\\newUNCPath\")

    Set-CMOperatingSystemImage -InputObject $Image -Path $newImagePath
    Write-Output $oldImagePath
    Write-Output $newImagePath

}