using namespace System

Set-StrictMode -Version Latest





################################################################################
#
# LOAD ALL TEH SCRIPT-ZORS
# IN THE WRITE ORDER
#
################################################################################

. "$($PSScriptRoot)/Util/CustomEvents.ps1"
. “$($PSScriptRoot)/Util/ClampableInt.ps1”
. “$($PSScriptRoot)/Util/ColorChannel.ps1”
. “$($PSScriptRoot)/Color/TrueColor.ps1”
. “$($PSScriptRoot)/Util/Context.ps1”
. “$($PSScriptRoot)/Util/ContextBroadcaster.ps1”
. "$($PSScriptRoot)/Util/BufferSpecDefinition.ps1"
. “$($PSScriptRoot)/Util/Janitor.ps1”
. "$($PSScriptRoot)/String/TIStringMode.ps1"
. "$($PSScriptRoot)/String/TIString.ps1"
. "$($PSScriptRoot)/String/StringAnimator.ps1"
. "$($PSScriptRoot)/Engine/GameCore.ps1"

[GameCore]$TheGameCore = [GameCore]::new()

$TheGameCore.Run()
