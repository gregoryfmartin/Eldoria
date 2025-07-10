using namespace System
using namespace System.Management.Automation.Host

Set-StrictMode -Version Latest

###############################################################################
#
# BUFFER MANAGER
#
###############################################################################

Class BufferManager {
    [BufferCell[,]]$ScreenBufferA
    [BufferCell[,]]$ScreenBufferB

    BufferManager() {
        $this.ScreenBufferA = New-Object 'BufferCell[,]' 80, 80
        $this.ScreenBufferB = New-Object 'BufferCell[,]' 80, 80
    }

    [Void]CopyActiveToBufferA() {
        $this.ScreenBufferA = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
    }

    [Void]CopyActiveToBufferAWithWipe() {
        $this.ScreenBufferA = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
        Clear-Host
    }

    [Void]CopyActiveToBufferB() {
        $this.ScreenBufferB = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
    }

    [Void]CopyActiveToBufferBWithWipe() {
        $this.ScreenBufferB = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
        Clear-Host
    }

    [Void]SwapAToB() {
        $this.ScreenBufferB = $this.ScreenBufferA
    }

    [Void]SwapBToA() {
        $this.ScreenBufferA = $this.ScreenBufferB
    }

    [Void]RestoreBufferAToActive() {
        Clear-Host
        $Script:Rui.SetBufferContents([Coordinates]::new(0, 0), $this.ScreenBufferA)
        $this.ScreenBufferA = New-Object 'BufferCell[,]' 80, 80
    }

    [Void]RestoreBufferBToActive() {
        Clear-Host
        $Script:Rui.SetBufferContents([Coordinates]::new(0, 0), $this.ScreenBufferB)
        $this.ScreenBufferB = New-Object 'BufferCell[,]' 80, 80
    }
}
