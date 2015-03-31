function GetHintPaths {
	param(
		[string] $CsProjFile = 'C:\src\trunk\ICTEAM.Solution\ICTEAM.Project1\ICTEAM.Project1.csproj'
	)
	
    [xml] $Xml = Get-Content $CsProjFile
    $NsMgr = New-Object System.Xml.XmlNamespaceManager($Xml.NameTable)
    $NsMgr.AddNamespace("ns", "http://schemas.microsoft.com/developer/msbuild/2003")
	$Xml.SelectNodes("//ns:HintPath", $NsMgr) |% { New-Object PSObject -Property @{CsProjFile="$CsProjFile";HintPath=$_.InnerText} }
}

function GetProjectReferences {
	param (
		[string] $CsProjFile = 'C:\src\trunk\ICTEAM.Solution\ICTEAM.Project1\ICTEAM.Project1.csproj'
	)

	[xml] $Xml = Get-Content $CsProjFile
	$Ns = New-Object System.Xml.XmlNamespaceManager($Xml.NameTable)
	$Ns.AddNamespace("ns", "http://schemas.microsoft.com/developer/msbuild/2003")

	$Xml.SelectNodes("//ns:ProjectReference", $Ns) | 
		ForEach-Object { $_.GetAttribute("Include") } | 
		% { New-Object PSObject -Property @{CsProjFile="$CsProjFile";ReferencedProject="$_"} }
}

function GetExternalProjectReferences {
	param (
		[string] $CsProjFile = 'C:\src\trunk\ICTEAM.Solution\ICTEAM.Project1\ICTEAM.Project1.csproj',
		[string] $ProjectReferencesFilter = '..\..\*'
	)
	
	GetProjectReferences -CsProjFile "$CsProjFile" |
	Where-Object { $_.ReferencedProject -like $ProjectReferencesFilter }
}

function GetReferencedAssemblies {
	param (
		[string] $AssemblyFile = 'C:\src\trunk\ICTEAM.Solution\ICTEAM.Project1\bin\debug\ICTEAM.Project1.dll'
	)
	
	$Assembly = [System.Reflection.Assembly]::LoadFrom($AssemblyFile)
	$Assembly.GetReferencedAssemblies();
}