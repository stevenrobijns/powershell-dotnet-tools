. .\update_references_and_packageconfigs.ps1



$featureBranchNameToDelete = "feature/ServiceBusContractsTo6.0.0-B020157"

$moduleFolders = GetAfcModules -Folder $baseFolder
$moduleFolders

$moduleFolders = $moduleFolders[0]

$moduleFolders |% {
    cd $_.Fullname;
    write-host $_.Fullname
    &git checkout develop 2>&1 | write-host
    &git branch -D $featureBranchNameToDelete 2>&1 | write-host
    &git push origin :$featureBranchNameToDelete 2>&1 | write-host
}