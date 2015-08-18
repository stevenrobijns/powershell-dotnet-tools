#purpose of this powershell script is to update a reference e.g. Pms.ServiceBus.Contracts 6.0.0 to Pms.ServiceBus.Contracts 6.1.0
#in the .csproj files and the nuget package.config files to then put these changes on a feature branch and push them to the remote repository.

$baseFolder = "C:\git\afc"
$packageToUpgrade = "Pms.ServiceBus.Contracts"
$changeAssemblyVersionTo = "6.0.0-B018"
$changeVersionTo = "6.0.0-B018"

. $PSScriptRoot\manage_nuget.ps1

$moduleFolders = GetAfcModules -Folder $baseFolder

$moduleFolders = $moduleFolders[0]

$moduleFolders |% { 
    "Navigating to {0}" -f $_.Fullname; 
    cd $_.Fullname;
        
    ExitWhenGitStatusNotClean -GitStatusLines $gitStatusLines;

    #$packagesGotUpdate = (UpdatePackagesConfig -Folder $_.Fullname)

    $projectFilesGotUpdate = (UpdateProjectFiles -Folder $_.Fullname);
    $projectFilesGotUpdate

}

function UpdatePackagesConfig{
    param($Folder)

    $pacackageConfigs = Get-ChildItem -Path $Folder -Recurse -Filter packages.config;

    Write-Output "Found following package.config files: ";
    $pacackageConfigs |% { $_.Fullname };

    $somePackagesAreChanged = $false;

    Foreach($packageconfig in $pacackageConfigs){        
        $xmlPath = $packageconfig.FullName;
        [xml] $xml = Get-Content $xmlPath

        $nodesToChange = $xml.packages.package | where { $_.id -eq $packageToUpgrade }

        $nodesToChange |% { $_.version=$changeVersionTo }

        if($nodesToChange){
            $xml.Save($xmlPath)
            $somePackagesAreChanged = $true;
            "Updated $xmlPath"
        }
    }
    return $somePackagesAreChanged;
}

function UpdateProjectFiles{
    param($Folder)

    $csProjFiles = Get-ChildItem -Path $Folder -Recurse -Filter *.csproj;

    Write-Output "Found following .csproj files: ";
    $csProjFiles |% { $_.Fullname };

    $someProjectFilesAreChanged = $false;

    Foreach($projFile in $csProjFiles){        
        $xmlPath = $projFile.FullName;
        [xml] $xml = Get-Content $xmlPath

        $referenceNodes = $xml.Project.ItemGroup.Reference
        
        $nodesToChange = $referenceNodes | where {$_.Include -like "$packageToUpgrade," }

        $nodesToChange |% { 
            
            $_.Include=$_.Include -replace "Version=*,","Version=$changeAssemblyVersionTo,"
        }
        
        if($nodesToChange){
            $xml.Save($xmlPath)
            $somePackagesAreChanged = $true;
            "Updated $xmlPath"
        }
    }

    return $someProjectFilesAreChanged;
}

function ExitWhenGitStatusNotClean{
    param (
        $GitStatusLines
    )
    
    $gitStatus = &git status --porcelain;

    $gitStatusLines = ($gitStatus -split '[\r\n]') |? {$_} 

    $gitStatusLines 

    $GitStatusLines |% { 
        if(-not $_.StartsWith("??")){
            Write-Output "There are staged or modified tracked files, script will abort!";
            break;
        }
    }
}



