using namespace System

Set-StrictMode -Version Latest





################################################################################
#
# GAME STATE
#
# DEFINES THE GLOBAL GAME STATE.
#
################################################################################

Enum GameState {
    Init
    Running
    BadEnvironment # USED WHEN SOMETHING ISN'T RIGHT WITH THE TERMINAL ENVIRONMENT
    Deinit
}

[GameState]$Global:CurrentGameState = [GameState]::Init
[GameState]$Global:PreviousGameState = $CurrentGameState

Function Set-NextGameState {
    Param(
        [GameState]$NextState
    )

    If($Global:CurrentGameState -EQ $NextState) {
        Return
    }

    $Global:PreviousGameState = $Global:CurrentGameState
    $Global:CurrentGameState = $NextState
}
