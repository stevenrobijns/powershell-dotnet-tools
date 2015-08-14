###############################################################################
#
# Functions to extract information from nuget files
#
###############################################################################

function GetPackageFiles {
    param (
        [string] $folder
    )
     Get-ChildItem -Path $folder -Filter packages.config -Recurse
}

function GetNuSpecFiles {
    param (
        [string] $folder
    )
    Get-ChildItem -Path $baseFolder -Filter *.nuspec -Recurse
}

function ReadPackagesConfig {
    param (
        [string] $file
    )

    [xml] $xml = Get-Content $file
    $xml.packages.package |% { New-Object PSObject -Property @{Id=$_.id;Version=$_.version;TargetFramework=$_.targetFramework} }
}

function ReadPackageId {
    param (
        [string] $file
    )

    [xml] $xml = Get-Content $file
    $xml.package.metadata.id
}

function GetPackageInfo {
    param (
        [string] $folder
    )
     
    $packageFiles = Get-ChildItem -Path $folder -Filter packages.config -Recurse
    $consumedPackages = @()
    $packageFiles |% { $consumedPackages += (ReadPackagesConfig -File $_.FullName) }
    
    $nuspecFiles = Get-ChildItem -Path $folder -Filter *.nuspec -Recurse
    $nuspecIds = @()
    $nuspecFiles |% { $nuspecIds += (ReadPackageId -File $_.FullName) }
    
    New-Object PSObject -Property @{ Module=$_.Name; ConsumedPackages=$consumedPackages; ProducedPackages=$nuspecIds }
}