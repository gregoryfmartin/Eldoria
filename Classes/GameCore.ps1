using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# GAME CORE
#
# ENTRY POINT FOR THE GAME PROGRAM
#
###############################################################################

Class GameCore {
    [Boolean]$GameRunning

    GameCore() {
        $this.GameRunning          = $true
        $Script:TheGlobalGameState = [GameStatePrimary]::TitleScreen
    }

    [Void]Run() {
        While($this.GameRunning -EQ $true) {
            $this.Logic()
        }
    }

    [Void]Logic() {
        Invoke-Command $Script:TheGlobalStateBlockTable[$Script:TheGlobalGameState]
        $Script:Rui.FlushInputBuffer()
    }
}
