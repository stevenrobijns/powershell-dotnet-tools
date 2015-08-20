. .\update_references_and_packageconfigs.ps1

$moduleFolders = GetAfcModules -Folder $baseFolder
$moduleFolders


$moduleFolders |%{
    &cd $_.Fullname;
    &git reset .
    &git checkout .
    &git clean -xdf
}