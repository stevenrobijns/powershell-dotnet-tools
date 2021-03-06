#This script lists all references for all .csproj files in a given directory recursively
#Fill in the Basepath of the solution for which you want to see the references
param(
    [string] $ExcelExePath = "C:\Program Files\Microsoft Office\Office14\EXCEL.EXE",
	[string] $BasePath = 'C:\workspace\MobiguiderV2\trunk\MobiGuider.DocumentManagement',
	[string] $OutFile = 'C:\temp\' + $BasePath.Replace("\","_").Replace(":","").Replace(" ","").ToLowerInvariant() + '_' +(get-date -format "yyyy-MM-dd_HH-mm-ss") + '.csv'
)

. .\manage_csproj.ps1

#get the content for the csv file
Get-ChildItem "$BasePath" -Name '*.csproj' -Recurse |% { "$BasePath\$_" } |% { GetHintPaths -CsProjFile "$_" } | Export-Csv "$OutFile" -NoTypeInformation

#set the seperator of the csv file to make sure excel opens the text in multiple columns
"sep=," | Insert-Content $outfile

#open the excel file
&"$ExcelExePath" "$OutFile"