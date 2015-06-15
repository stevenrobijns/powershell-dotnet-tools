# This script makes it able to see all the references for each dll in a specified directory
# This can especially come in handy when you're getting a compile error message like : "Could not load file or assembly" which you know off you shouldn't be referencing it
# The line ". .\manage_csproj.ps1" will only work when you change your current working directory to the directory of the manage_csproj.ps1 file when executing from PowerShell ISE
# To do that just open the script in the powershell_ise and type cd YOURDISK:\YOURWORKSPACE\powershell-dotnet-tools in the command line
param( 
    [string] $ExcelExePath = "C:\Program Files\Microsoft Office\Office14\EXCEL.EXE",
	[string] $BasePath = 'C:\workspace\MobiguiderV2\trunk\MobiGuider.TariffManagement\Pms.TariffManagement.UI.Shell\bin\Debug\DirectoryModules\',
	[string] $OutFile = 'C:\temp\' + $BasePath.Replace("\","_").Replace(":","").Replace(" ","").ToLowerInvariant() + '_' +(get-date -format "yyyy-MM-dd_HH-mm-ss") + '.csv'
)

. .\manage_csproj.ps1

Get-ChildItem "$BasePath" -Name '*.dll' -Recurse |% { "$BasePath\$_" } |% { GetReferencedAssemblies -AssemblyFile "$_" } | Export-Csv "$OutFile"
&"$ExcelExePath" "$OutFile"



