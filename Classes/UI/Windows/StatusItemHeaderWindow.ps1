using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# STATUS ITEM HEADER WINDOW
#
# DISPLAYS A SUMMARY OF THE CURRENTLY SELECTED ITEM FROM THE STATUS ITEM
# INVENTORY WINDOW.
#
###############################################################################
    
Class StatusItemHeaderWindow : WindowBase {
    Static [Int]$WindowLTRow    = 1
    Static [Int]$WindowLTColumn = 13
    Static [Int]$WindowRBRow    = 6
    Static [Int]$WindowRBColumn = 68

    Static [String]$WindowTitle = 'Description'

    StatusItemHeaderWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [StatusItemHeaderWindow]::WindowLTRow
            Column = [StatusItemHeaderWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [StatusItemHeaderWindow]::WindowRBRow
            Column = [StatusItemHeaderWindow]::WindowRBColumn
        }

        $this.UpdateDimensions()
        $this.SetupTitle([StatusItemHeaderWindow]::WindowTitle, [CCTextDefault24]::new())
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()
    }
}