###############################################################################
#
# ELDORIA
# WRITTEN BY GREGORY F MARTIN
#
###############################################################################





###############################################################################
#
# LOAD ENUMS
#
###############################################################################

Foreach($File in (Get-ChildItem "$($PSScriptRoot)/Source/Enums")) {
    . $File
}





###############################################################################
#
# LOAD UTILS
#
###############################################################################

[String]$DirEvents       = "$($PSScriptRoot)/Source/Events"
[String]$DirUtil         = "$($PSScriptRoot)/Source/Util"
[String]$DirStateMachine = "$($PSScriptRoot)/Source/StateMachine"

. "$($DirEvents)/CustomEvents.ps1"
. "$($DirUtil)/Context.ps1"
. "$($DirUtil)/ContextBroadcaster.ps1"
. "$($DirUtil)/ClampableInt.ps1"
. "$($DirUtil)/BufferSpecDefinition.ps1"
. "$($DirUtil)/Janitor.ps1"
. "$($DirUtil)/Functions.ps1"
. "$($DirStateMachine)/SMState.ps1"
. "$($DirStateMachine)/SMTransition.ps1"
. "$($DirStateMachine)/SMStateMachine.ps1"





###############################################################################
#
# LOAD COLOR SUPPORT
#
###############################################################################

[String]$DirColor = "$($PSScriptRoot)/Source/Color"

. "$($DirColor)/ColorChannel.ps1"
. "$($DirColor)/TrueColor.ps1"





###############################################################################
#
# LOAD STRING SUPPORT
#
###############################################################################

[String]$DirString = "$($PSScriptRoot)/Source/String"

. "$($DirString)/ATControlSequences.ps1"
. "$($DirString)/ATDecoration.ps1"
. "$($DirString)/ATDecorationNone.ps1"
. "$($DirString)/ATCoordinates.ps1"
. "$($DirString)/ATCoordinatesDefault.ps1"
. "$($DirString)/ATCoordinatesNone.ps1"
. "$($DirString)/ATBackgroundColor24.ps1"
. "$($DirString)/ATBackgroundColor24None.ps1"
. "$($DirString)/ATForegroundColor24.ps1"
. "$($DirString)/ATForegroundColor24None.ps1"
. "$($DirString)/ATStringPrefix.ps1"
. "$($DirString)/ATStringPrefixNone.ps1"
. "$($DirString)/ATString.ps1"
. "$($DirString)/ATStringNone.ps1"
. "$($DirString)/ATStringComposite.ps1"
. "$($DirString)/ATSceneImageString.ps1"
. "$($DirString)/SceneImage.ps1"
. "$($DirString)/SIEmpty.ps1"
. "$($DirString)/SIInternalBase.ps1"
. "$($DirString)/SIRandomNoise.ps1"
. "$($DirString)/EnemyEntityImage.ps1"
. "$($DirString)/EEIEmpty.ps1"
. "$($DirString)/EEIInternalBase.ps1"





###############################################################################
#
# LOAD UI SUPPORT
#
###############################################################################

[String]$DirUi = "$($PSScriptRoot)/Source/UI"

. "$($DirUi)/UIBase.ps1"
. "$($DirUi)/UILabel.ps1"
# . "$($DirUi)/UIContainer.ps1"





###############################################################################
#
# LOAD STATES
#
###############################################################################

[String]$DirStates = "$($PSScriptRoot)/Source/Engine/States"

Foreach($File in (Get-ChildItem -Path "$($DirStates)/Game")) {
    . $File
}





###############################################################################
#
# LOAD THE GAME CORE
#
###############################################################################

. "$($PSScriptRoot)/Source/Engine/GameCore.ps1"
. "$($PSScriptRoot)/Source/Engine/EldoriaCore.ps1"

[EldoriaCore]$EldCore = [EldoriaCore]::new()
$EldCore.Run()
