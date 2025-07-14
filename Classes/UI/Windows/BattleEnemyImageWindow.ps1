using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BATTLE ENEMY IMAGE WINDOW
#
###############################################################################

Class BattleEnemyImageWindow : WindowBase {
    Static [Int]$WindowLTRow           = 1
    Static [Int]$WindowLTColumn        = 43
    Static [Int]$WindowRBRow           = 17
    Static [Int]$WindowRBColumn        = 81
    Static [Int]$ImageDrawRowOffset    = [BattleEnemyImageWindow]::WindowLTRow + 1
    Static [Int]$ImageDrawColumnOffset = [BattleEnemyImageWindow]::WindowLTColumn + 1

    [Boolean]$ImageDirty
    [ATCoordinates]$ImageDrawCoords
    [EnemyEntityImage]$Image

    BattleEnemyImageWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [BattleEnemyImageWindow]::WindowLTRow
            Column = [BattleEnemyImageWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [BattleEnemyImageWindow]::WindowRBRow
            Column = [BattleEnemyImageWindow]::WindowRBColumn
        }

        $this.UpdateDimensions()

        $this.SetupTitle("$($Script:TheCurrentEnemy.Name)", [CCTextDefault24]::new())

        $this.ImageDirty      = $true
        $this.Image           = [EEIEmpty]::new()
        $this.ImageDrawCoords = [ATCoordinates]@{
            Row    = [BattleEnemyImageWindow]::ImageDrawRowOffset
            Column = [BattleEnemyImageWindow]::ImageDrawColumnOffset
        }
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()
        If($this.ImageDirty -EQ $true) {
            $this.Image = $Script:TheCurrentEnemy.Image
            Write-Host "$($this.Image.ToAnsiControlSequenceString())"
            $this.ImageDirty = $false
        }
    }
}
