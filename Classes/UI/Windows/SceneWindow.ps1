using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SCENE WINDOW
#
# THIS WINDOW DISPLAYS AN IMAGE FOR THE CURRENT MAP TILE. THIS IS A VISUAL
# HACK TO GIVE A VISUAL FLAIR TO THE PROGRAM.
#
###############################################################################

Class SceneWindow : WindowBase {
    Static [Int]$WindowLTRow           = 4
    Static [Int]$WindowLTColumn        = 31
    Static [Int]$WindowRBRow           = 23
    Static [Int]$WindowRBColumn        = 80
    Static [Int]$ImageDrawRowOffset    = [SceneWindow]::WindowLTRow + 1
    Static [Int]$ImageDrawColumnOffset = [SceneWindow]::WindowLTColumn + 1

    Static [String]$WindowTitle = 'Scene'

    Static [ATCoordinates]$SceneImageDrawCoordinates = [ATCoordinatesNone]::new()

    [Boolean]$SceneImageDirty
    [SceneImage]$Image

    SceneWindow() : base() {
        $this.LeftTop     = [ATCoordinates]::new([SceneWindow]::WindowLTRow, [SceneWindow]::WindowLTColumn)
        $this.RightBottom = [ATCoordinates]::new([SceneWindow]::WindowRBRow, [SceneWindow]::WindowRBColumn)

        $this.UpdateDimensions()
        $this.SetupTitle([SceneWindow]::WindowTitle, [CCTextDefault24]::new())

        $this.SceneImageDirty = $true
        $this.Image           = [SIEmpty]::new()

        [SceneWindow]::SceneImageDrawCoordinates = [ATCoordinates]@{
            Row    = [SceneWindow]::ImageDrawRowOffset
            Column = [SceneWindow]::ImageDrawColumnOffset
        }
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.SceneImageDirty -EQ $true) {
            # THRE MAY BE AN OPPORTUNITY TO DO SOMETHING A BIT DIFFERENT HERE
            $this.Image = $Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage
            Write-Host "$($this.Image.ToAnsiControlSequenceString())"
            $this.SceneImageDirty = $false
        }
    }

    [Void]UpdateCurrentImage(
        [SceneImage]$NewImage
    ) {
        $this.Image           = $NewImage
        $this.SceneImageDirty = $true
    }

    [Void]SetAllDirty() {
        ([WindowBase]$this).SetAllDirty()

        $this.SceneImageDirty = $true
    }
}

