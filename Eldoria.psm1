$PrivateFunctions = Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1"
Foreach($File in $PrivateFunctions) {
    . $File.FullName
}

$PublicFunctions = Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1"
Foreach($File in $PublicFunctions) {
    . $File.FullName
}

$Classes = Get-ChildItem -Path "$PSScriptRoot\Classes\*.ps1"
Foreach($File in $Classes) {
    . $File.FullName
}