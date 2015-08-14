. .\manage_nuget.ps1

function GetModuleByProducedPackage {
    param(
        $moduleInfos
    )

    $producedPackages = @{}
    $moduleInfos |% {
        $module = $_.Module
        $_.ProducedPackages |% { 
            $package = $_
            $producedPackages[$package] = $module
        }
    }
    $producedPackages
}

function GetIdByModule {
    param(
        $moduleInfos
    )

    $moduleIds = @{}
    for($i = 0; $i -lt $moduleInfos.Length; ++$i) {
        $module = $moduleInfos[$i].Module
        $id = $i+1
        $moduleIds[$module] = $id
    }
    $moduleIds
}

function CollectDependencies {
    param(
        $moduleInfos
    )

    $moduleIds = GetIdByModule -moduleInfos $moduleInfos
    $producedPackages = GetModuleByProducedPackage -moduleInfos $moduleInfos

    $dependencies = @()
    $moduleInfos |% {
        $fromModule = $_.Module
        $fromId = $moduleIds[$fromModule]
        $_.ConsumedPackages |% {
            $consumedPackageId = $_.Id
            if($producedPackages.ContainsKey($consumedPackageId)) {
                $toModule = $producedPackages[$consumedPackageId]
                $toId = $moduleIds[$toModule]
                $dependencies += New-Object PSObject -Property @{ From=$fromModule; FromId=$fromId; To=$toModule; ToId=$toId }
            }
        }
    }
    $dependencies
}

function GetAfcModules {
    param (
        [string] $folder
    )
    Get-ChildItem -Path $baseFolder -Filter AFC*
}


$baseFolder = "c:\src"
$moduleFolders = GetAfcModules -Folder $baseFolder
$moduleInfos = $moduleFolders |% { GetPackageInfo -Folder $_.FullName }
#CollectDependencies -moduleInfos $moduleInfos | Sort-Object | Get-Unique 

