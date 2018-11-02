<#
#SCCM App Model
#Change DT Content Location for Applications
#MSI or Script install only
#RChapman
#
#>

#$Applications = @("ApplicationOne")
$Applications = Get-Content -Path "D:\rivePath\FileList.txt"



foreach ($app in $Applications){

    $theApplication = Get-CMApplication -Name $app

    #XML data with details for the deployment type including
    #content location
    $AppMgmt = ([xml]$theApplication.SDMPackageXML).AppMgmtDigest

    Foreach($DeploymentType in $AppMgmt.DeploymentType)
    {
        $ContentLocation = $DeploymentType.Installer.Contents.Content.Location
        Write-Output $ContentLocation
        [string]$newLocation = $ContentLocation.Replace("\\oldUNCPath\","\\newUNCPath\")

        Write-Output $newLocation

        Set-CMDeploymentType -ApplicationName ($theApplication.LocalizedDisplayName) -DeploymentTypeName ($DeploymentType.Title.InnerText) -ContentLocation $newLocation -MsiOrScriptInstaller

    }
}
