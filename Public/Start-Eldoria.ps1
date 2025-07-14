using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# START-ELDORIA.PS1
#
# STARTS THE ELDORIA GAME
#
###############################################################################

Function Start-Eldoria {
    Clear-Host

    $Script:TheGameCore.Run()
}
