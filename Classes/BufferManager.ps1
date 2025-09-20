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

    # [BufferCell[,]]$ScreenBufferA
    # [BufferCell[,]]$ScreenBufferB

    BufferManager() {
        # $this.ScreenBufferA = New-Object 'BufferCell[,]' 80, 80
        # $this.ScreenBufferB = New-Object 'BufferCell[,]' 80, 80
    }

    # [Void]CopyActiveToBufferA() {
    #     $this.ScreenBufferA = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
    # }

    # [Void]CopyActiveToBufferAWithWipe() {
    #     $this.ScreenBufferA = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
    #     Clear-Host
    # }

    # [Void]CopyActiveToBufferB() {
    #     $this.ScreenBufferB = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
    # }

    # [Void]CopyActiveToBufferBWithWipe() {
    #     $this.ScreenBufferB = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
    #     Clear-Host
    # }

    # [Void]SwapAToB() {
    #     $this.ScreenBufferB = $this.ScreenBufferA
    # }

    # [Void]SwapBToA() {
    #     $this.ScreenBufferA = $this.ScreenBufferB
    # }

    # [Void]RestoreBufferAToActive() {
    #     Clear-Host
    #     $Script:Rui.SetBufferContents([Coordinates]::new(0, 0), $this.ScreenBufferA)
    #     $this.ScreenBufferA = New-Object 'System.Management.Automation.Host.BufferCell[,]' 80, 80
    # }

    # [Void]RestoreBufferBToActive() {
    #     Clear-Host
    #     $Script:Rui.SetBufferContents([Coordinates]::new(0, 0), $this.ScreenBufferB)
    #     $this.ScreenBufferB = New-Object 'System.Management.Automation.Host.BufferCell[,]' 80, 80
    # }

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
