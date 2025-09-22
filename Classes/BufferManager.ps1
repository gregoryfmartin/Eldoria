using namespace System
using namespace System.Management.Automation.Host

Set-StrictMode -Version Latest

###############################################################################
#
# BUFFER MANAGER
#
###############################################################################

Class BufferManager {
    Static [Int]$BufferClearLeft   = 0
    Static [Int]$BufferClearTop    = 0
    Static [Int]$BufferClearRight  = 90
    Static [Int]$BufferClearBottom = 40

    Static [ATCoordinates]$BufferClearLeftTop = [ATCoordinates]@{
        Row    = [BufferManager]::BufferClearTop
        Column = [BufferManager]::BufferClearLeft
    }
    Static [ATCoordinates]$BufferClearRightBottom = [ATCoordinates]@{
        Row    = [BufferManager]::BufferClearBottom
        Column = [BufferManager]::BufferClearRight
    }

    BufferManager() {}

    [Void]ClearArea(
        [Int]$Top,
        [Int]$Left,
        [Int]$Width,
        [Int]$Height
    ) {
        $Script:Rui.CursorPosition = ([ATCoordinates]::new($Top, $Left)).ToAutomationCoordinates()
        
        For([Int]$Row = $Top; $Row -LT $Height; $Row++) {
            Write-Host "$(' ' * ($Width - $Left))"
            $Script:Rui.CursorPosition = ([ATCoordinates]::new($Row, $Left)).ToAutomationCoordinates()
        }
    }

    [Void]ClearArea(
        [ATCoordinates]$LeftTop,
        [ATCoordinates]$RightBottom,
        [Int]$ColAdjust
    ) {
        $Script:Rui.CursorPosition = $LeftTop.ToAutomationCoordinates()

        For([Int]$Row = $LeftTop.Row; $Row -LT $RightBottom.Row; $Row++) {
            Write-Host "$(' ' * (($RightBottom.Column - $LeftTop.Column) - $ColAdjust))"
            $Script:Rui.CursorPosition = ([ATCoordinates]::new($Row, $LeftTop.Column)).ToAutomationCoordinates()
        }
    }

    [Void]ClearCommon() {
        $this.ClearArea(
            [BufferManager]::BufferClearLeftTop,
            [BufferManager]::BufferClearRightBottom,
            0
        )
    }
}
