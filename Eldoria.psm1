$PrivateFunctions = Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1"
Foreach($File in $PrivateFunctions) {
    . $File.FullName
}

$PublicFunctions = Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1"
Foreach($File in $PublicFunctions) {
    . $File.FullName
}

$ColorSupport = Get-ChildItem -Path "$PSScriptRoot\Classes\ConsoleColor\CC*.ps1"
. "$PSScriptRoot\Classes\ConsoleColor\ConsoleColor24.ps1"
Foreach($File in $ColorSupport) {
    . $File.FullName
}

#//////////////////////////////////////////////////////////////////////////////
# AT STRING SUPPORT
#//////////////////////////////////////////////////////////////////////////////
. "$PSScriptRoot\Classes\ATStrings\ATControlSequences.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATForegroundColor.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATForegroundColorNone.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATBackgroundColor.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATBackgroundColorNone.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATDecoration.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATDecorationNone.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATCoordinates.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATCoordinatesNone.ps1"

#$Classes = Get-ChildItem -Path "$PSScriptRoot\Classes\*.ps1"
#Foreach($File in $Classes) {
#    . $File.FullName
#}
