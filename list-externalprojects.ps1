#This script lists all the external project references for all the .csproj files in a given directory
param(
    [string] $ExcelExePath = "C:\Program Files\Microsoft Office\Office14\EXCEL.EXE",
	[string] $BasePath = 'C:\workspace\MobiguiderV2\trunk\MobiGuider.DocumentManagement',
	[string] $OutFile = 'C:\temp\' + $BasePath.Replace("\","_").Replace(":","").Replace(" ","").ToLowerInvariant() + '_' +(get-date -format "yyyy-MM-dd_HH-mm-ss") + '.csv'
)

. .\manage_csproj.ps1

Get-ChildItem "$BasePath" -Name '*.csproj' -Recurse |% { "$BasePath\$_" } |% { GetExternalProjectReferences -CsProjFile "$_" } | Export-Csv "$OutFile"
&"$ExcelExePath" "$OutFile"



