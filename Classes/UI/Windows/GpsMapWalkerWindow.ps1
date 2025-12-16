using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# GPS MAP WALKER WINDOW
#
# THIS IS THE NEW WINDOW THE PLAYER WILL USE TO WALK AROUND THE MAP ON.
#
# FOR NOW, THIS WINDOW IS A PLACEHOLDER.
#
###############################################################################

Class GpsMapWalkerWindow : WindowBase {
    Static [Int]$WindowLTRow    = 4
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowRBRow    = 15
    Static [Int]$WindowRBColumn = 30

    Static [String]$WindowTitle = 'Nav'

    [Int]$MapExamineArea
    [Boolean]$IsBorderUpdated
    [UIELabel[]]$MapTileSymbols
    [ATCoordinates]$MinimapDrawOriginOffset

    GpsMapWalkerWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [GpsMapWalkerWindow]::WindowLTRow
            Column = [GpsMapWalkerWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [GpsMapWalkerWindow]::WindowRBRow
            Column = [GpsMapWalkerWindow]::WindowRBColumn
        }

        $this.UpdateDimensions()
        $this.SetupTitle(
            [GpsMapWalkerWindow]::WindowTitle,
            [CCTextDefault24]::new()
        )

        $this.MapExamineArea = 0
        $this.IsBorderUpdated = $false
        $this.MapTileSymbols = @()
        $this.MinimapDrawOriginOffset = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 2
            Column = $this.LeftTop.Column + 2
        }
    }

    [Void]Draw() {
        If($this.IsBorderUpdated -EQ $false) {
            [MapTile]$CurrentTile = $Script:CurrentMap.GetTileAtPlayerCoordinates()

            If($CurrentTile.Exits[[MapTile]::TileExitNorth] -EQ $true) {
                $this.BorderDrawColors[[WindowBorderPart]::Top]     = [CCAppleGreenLight24]::new()
                $this.BorderDrawDirty[[WindowBorderPartDirty]::Top] = $true
            } Else {
                $this.BorderDrawColors[[WindowBorderPart]::Top]     = [CCAppleRedLight24]::new()
                $this.BorderDrawDirty[[WindowBorderPartDirty]::Top] = $true
            }

            If($CurrentTile.Exits[[MapTile]::TileExitSouth] -EQ $true) {
                $this.BorderDrawColors[[WindowBorderPart]::Bottom]     = [CCAppleGreenLight24]::new()
                $this.BorderDrawDirty[[WindowBorderPartDirty]::Bottom] = $true
            } Else {
                $this.BorderDrawColors[[WindowBorderPart]::Bottom]     = [CCAppleRedLight24]::new()
                $this.BorderDrawDirty[[WindowBorderPartDirty]::Bottom] = $true
            }

            If($CurrentTile.Exits[[MapTile]::TileExitEast] -EQ $true) {
                $this.BorderDrawColors[[WindowBorderPart]::Right]     = [CCAppleGreenLight24]::new()
                $this.BorderDrawDirty[[WindowBorderPartDirty]::Right] = $true
            } Else {
                $this.BorderDrawColors[[WindowBorderPart]::Right]     = [CCAppleRedLight24]::new()
                $this.BorderDrawDirty[[WindowBorderPartDirty]::Right] = $true
            }

            If($CurrentTile.Exits[[MapTile]::TileExitWest] -EQ $true) {
                $this.BorderDrawColors[[WindowBorderPart]::Left]     = [CCAppleGreenLight24]::new()
                $this.BorderDrawDirty[[WindowBorderPartDirty]::Left] = $true
            } Else {
                $this.BorderDrawColors[[WindowBorderPart]::Left]     = [CCAppleRedLight24]::new()
                $this.BorderDrawDirty[[WindowBorderPartDirty]::Left] = $true
            }

            $this.IsBorderUpdated = $true
        }

        ([WindowBase]$this).Draw()
    }
    
    [Void]SetAllDirty() {
        ([WindowBase]$this).SetAllDirty()
        
        $this.IsBorderUpdated = $false
    }
}