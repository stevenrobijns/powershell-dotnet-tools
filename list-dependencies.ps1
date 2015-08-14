﻿param(
	[string] $BasePath = 'C:\src\trunk\',
	[string] $OutFile = 'C:\temp\' + $BasePath.Replace("\","_").Replace(":","").Replace(" ","").ToLowerInvariant() + '_' +(get-date -uformat "%Y-%m-%D-%H-%M-%S") + '.csv'
)

. .\manage_assembly.ps1

Get-ChildItem "$BasePath" -Name '*.dll' -Recurse |% { "$BasePath\$_" } |% { GetReferencedAssemblies -AssemblyFile "$_" } | Export-Csv "$OutFile"
&"C:\Program Files\Microsoft Office 15\root\office15\EXCEL.EXE" "$OutFile"



