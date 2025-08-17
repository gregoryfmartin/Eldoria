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
    Static [Int]$WindowRBRow    = 4
    Static [Int]$WindowRBColumn = 68

    Static [String]$WindowTitle = 'Description'
    
    [ATString]$ItemDesc
    [ATString]$ItemEffect
    
    [Boolean]$ItemDescDirty
    [Boolean]$ItemEffectDirty

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
        
        $this.ItemDesc = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates = [ATCoordinates]@{
                    Row = $this.LeftTop.Row + 1
                    Column = $this.LeftTop.Column + 2
                }
            }
            UserData = "$('A' * ($this.Width - 3))"
            UseATReset = $true
        }
        $this.ItemEffect = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates = [ATCoordinates]@{
                    Row = $this.ItemDesc.Prefix.Coordinates.Row + 1
                    Column = $this.ItemDesc.Prefix.Coordinates.Column
                }
            }
            UserData = "$('A' * ($this.Width - 3))"
            UseATReset = $true
        }
        $this.ItemDescDirty = $true
        $this.ItemEffectDirty = $true
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()
        
        If($this.ItemDescDirty -EQ $true) {
            Write-Host "$($this.ItemDesc.ToAnsiControlSequenceString())"
            $this.ItemDescDirty = $false
        }
        If($this.ItemEffectDirty -EQ $true) {
            Write-Host "$($this.ItemEffect.ToAnsiControlSequenceString())"
            $this.ItemEffectDirty = $false
        }
    }
    
    [Void]UpdateItemDesc(
        [String]$ItemDesc
    ) {
        $this.ItemDesc.UserData = $ItemDesc
        $this.ItemDescDirty = $true
    }
    
    [Void]UpdateItemEffect(
        [String]$ItemEffect
    ) {
        $this.ItemEffect.UserData = $ItemEffect
        $this.ItemEffectDirty = $true
    }
}