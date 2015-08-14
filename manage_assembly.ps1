###############################################################################
#
# Functions to extract information from a dotnet Assembly file
#
###############################################################################

function GetReferencedAssemblies {
	param (
		[string] $AssemblyFile = 'C:\src\trunk\ICTEAM.Solution\ICTEAM.Project1\bin\debug\ICTEAM.Project1.dll'
	)
	
	$ScriptBlock = {
		param (
			[string] $AssemblyFile = 'C:\src\trunk\ICTEAM.Solution\ICTEAM.Project1\bin\debug\ICTEAM.Project1.dll'
		)

		$Assembly = [System.Reflection.Assembly]::LoadFrom("$AssemblyFile")
		$Assembly.GetReferencedAssemblies() |% { New-Object PSObject -Property @{AssemblyFile="$AssemblyFile";ReferencedAssembly="$_"} }
	}
	
	powershell -Command $ScriptBlock -args "$AssemblyFile"
}