using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# HORIZONTAL GPS STATUS WINDOW
#
# A NEW WINDOW USED IN THE NAVIGATION SCREEN. THIS WINDOW DOES THE SAME EXACT
# THING THAT THE LEGACY STATUS WINDOW DID, JUST DISPLAYED IN A HORIZONTAL
# FASHION. IT ALSO TRIMS OFF SOME DATA TO MAKE IT MORE STREAMLINED.
#
###############################################################################

Class HorizontalGpsStatusWindow : WindowBase {
    Static [Int]$PlayerStatDrawColumn = 3
    Static [Int]$PlayerStatDrawRow    = 2
    Static [Int]$WindowLTRow          = 1
    Static [Int]$WindowLTColumn       = 1
    Static [Int]$WindowRBRow          = 3
    Static [Int]$WindowRBColumn       = 80
    
    Static [String]$WindowTitle = 'Status'
    
    [UIELabel[]]$Labels
    
    HorizontalGpsStatusWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [HorizontalGpsStatusWindow]::WindowLTRow
            Column = [HorizontalGpsStatusWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [HorizontalGpsStatusWindow]::WindowRBRow
            Column = [HorizontalGpsStatusWindow]::WindowRBColumn
        }
        
        $this.UpdateDimensions()
        $this.SetupTitle(
            [HorizontalGpsStatusWindow]::WindowTitle,
            [CCTextDefault24]::new()
        )
        #$this.SetupLabels()
    }
    
    [Void]SetupLabels() {
        $this.Labels = @(
            [UIELabel]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 1
                        Column = $this.LeftTop.Column + 1
                    }
                }
                UseATReset = $true
                Dirty = $true
            }
        )

        $this.Labels[0].SetUserData("$($Script:ThePlayer.Name)")
    }
    
    [Void]Draw() {
        ([WindowBase]$this).Draw()
        
        Foreach($Label in $this.Labels) {
            $Label.Draw()
        }
    }
}