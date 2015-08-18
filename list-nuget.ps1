. .\manage_nuget.ps1

$baseFolder = "c:\src"
$moduleFolders = GetAfcModules -Folder $baseFolder
$moduleInfos = $moduleFolders |% { GetPackageInfo -Folder $_.FullName }
#CollectDependencies -moduleInfos $moduleInfos | Sort-Object | Get-Unique 

