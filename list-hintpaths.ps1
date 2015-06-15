#This script lists all references for all .csproj files in a given directory recursively
#Fill in the Basepath of the solution for which you want to see the references
param(
    [string] $ExcelExePath = "C:\Program Files\Microsoft Office\Office14\EXCEL.EXE",
	[string] $BasePath = 'C:\workspace\MobiguiderV2\trunk\MobiGuider.DocumentManagement',
	[string] $OutFile = 'C:\temp\' + $BasePath.Replace("\","_").Replace(":","").Replace(" ","").ToLowerInvariant() + '_' +(get-date -format "yyyy-MM-dd_HH-mm-ss") + '.csv'
)

Write-Output $OutFile

. .\manage_csproj.ps1

Get-ChildItem "$BasePath" -Name '*.csproj' -Recurse |% { "$BasePath\$_" } |% { GetHintPaths -CsProjFile "$_" } | Export-Csv "$OutFile"
&"$ExcelExePath" "$OutFile"