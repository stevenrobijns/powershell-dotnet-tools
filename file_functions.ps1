#insert text at the top of a file
function Insert-Content {
	param ( [String]$Path )
	process {
			$( ,$_; Get-Content $Path -ea SilentlyContinue) | Out-File $Path
		}
}