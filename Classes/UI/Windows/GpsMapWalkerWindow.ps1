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
    Static [Int]$WindowLTRow = 4
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowRBRow = 23
    Static [Int]$WindowRBColumn = 30
    
    Static [String]$WindowTitle = 'Nav'
    
    GpsMapWalkerWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row = [GpsMapWalkerWindow]::WindowLTRow
            Column = [GpsMapWalkerWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row = [GpsMapWalkerWindow]::WindowRBRow
            Column = [GpsMapWalkerWindow]::WindowRBColumn
        }
        
        $this.UpdateDimensions()
        $this.SetupTitle(
            [GpsMapWalkerWindow]::WindowTitle,
            [CCTextDefault24]::new()
        )
    }
}