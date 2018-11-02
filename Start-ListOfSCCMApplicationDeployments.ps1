<# Script: Deploy List of SCCM Applications
# Author: R Chapman
# Date: 7-20-2018
#Description: Pass list of SCCM Applications and an SCCM Collection to configure deployments
#>


<#

    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER pListOfApplications
        A string array of the SCCM Applications to deploy.  Something like this: $Apps = @(Get-Content -Path .\AppList.txt).
        See examples.
    .PARAMETER pComputerCollection
        String name of computer collection to target with the applicaiton deployments
    .PARAMETER pStartDateTime
        The start time for the deployments, defaults to 11:00 PM today.

    .PARAMETER pDeadlineDateTime
        The deadline for deploymenys, defaults to 1:00 AM tomorrow

    .PARAMETER pInstallOutsideOfMaintWindows
       Allow installation outside of maintance windows, defaults to False
    .INPUTS
        A string of SCCM Applications to deploy.  Somthing like this: $Apps = @(Get-Content -Path .\AppList.txt).
        See examples.
    .OUTPUTS

    .EXAMPLE
        $Apps = @(Get-Content -Path .\AppList.txt); $Apps | .\Start-ListOfSCCMApplicationDeployments.ps1 -pComputerCollection Empty


#>

[cmdletBinding()]
param(
    [Parameter(
        Mandatory = $true,
        ValueFromPipeline = $true
    )]
    [string[]] $pListOfApplications,

    [Parameter(
        Mandatory = $true,
        ValueFromPipeline = $false
    )]
    [string] $pComputerCollection,

    [Parameter(
        Mandatory = $false,
        ValueFromPipeline = $false
    )]
    [datetime] $pStartDateTime = (Get-Date -Date ([datetime]::Today) -Hour 23 -Minute 00),

    [Parameter(
        Mandatory = $false,
        ValueFromPipeline = $false
    )]
    [datetime] $pDeadlineDateTime = (Get-Date -Date ([datetime]::Today) -Hour 01 -Minute 00).AddDays(1),

    [Parameter(
        Mandatory = $false,
        ValueFromPipeline = $false
    )]
    [bool] $pInstallOutsideOfMaintWindow = $false
)

BEGIN {
    Write-Verbose "Computer Collection is $pComputerCollection"
    Write-Verbose "List of Applications: $pListOfApplications"
    Write-Verbose "Start date is: $pStartDateTime"
    Write-Verbose "Deadline date is: $pDeadlineDateTime"

    #Store path where script was started so we can change to SCCM PS Drive and then back again on end
    $ScriptPath = Split-Path -Parent $PSCommandPath
    Import-Module 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1'

    #Default to our site code for now
    Set-Location P02:

}

PROCESS {

    foreach($application in $pListOfApplications){
        New-CMApplicationDeployment -Name $application -CollectionName $pComputerCollection -DeployAction Install -DeployPurpose Required -OverrideServiceWindow $pInstallOutsideOfMaintWindow `
        -RebootOutsideServiceWindow $false -SendWakeupPacket $True -TimeBaseOn LocalTime -UserNotification HideAll -DeadlineDateTime $pDeadlineDateTime -AvailableDateTime $pStartDateTime
    }
}


END {
    Set-Location $ScriptPath

}