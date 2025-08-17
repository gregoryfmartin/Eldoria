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

    Static [String]$WindowTitle   = 'Description'
    Static [String]$LineBlankData = ' ' * (([StatusItemHeaderWindow]::WindowRBColumn - [StatusItemHeaderWindow]::WindowLTColumn) - 2)
    
    [ATString]$ItemDesc
    [ATString]$ItemEffect
    [ATString]$LineBlankActual
    
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
                Coordinates     = [ATCoordinates]@{
                    Row    = $this.LeftTop.Row + 1
                    Column = $this.LeftTop.Column + 2
                }
            }
            UserData   = "$(' ' * ($this.Width - 3))"
            UseATReset = $true
        }
        $this.ItemEffect = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates     = [ATCoordinates]@{
                    Row    = $this.ItemDesc.Prefix.Coordinates.Row + 1
                    Column = $this.ItemDesc.Prefix.Coordinates.Column
                }
            }
            UserData   = "$(' ' * ($this.Width - 3))"
            UseATReset = $true
        }
        $this.LineBlankActual = [ATString]@{
            Prefix = [ATStringPrefix]@{
                Coordinates = [ATCoordinates]@{
                    Row    = 1
                    Column = 1
                }
            }
            UserData   = "$([StatusItemHeaderWindow]::LineBlankData)"
            UseATReset = $true
        }
        $this.ItemDescDirty   = $true
        $this.ItemEffectDirty = $true
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()
        
        If($this.ItemDescDirty -EQ $true) {
            $this.LineBlankActual.Prefix.Coordinates = [ATCoordinates]@{
                Row    = $this.ItemDesc.Prefix.Coordinates.Row
                Column = $this.ItemDesc.Prefix.Coordinates.Column
            }
            Write-Host "$($this.LineBlankActual.ToAnsiControlSequenceString())$($this.ItemDesc.ToAnsiControlSequenceString())"
            $this.ItemDescDirty = $false
        }
        If($this.ItemEffectDirty -EQ $true) {
            $this.LineBlankActual.Prefix.Coordinates = [ATCoordinates]@{
                Row    = $this.ItemEffect.Prefix.Coordinates.Row
                Column = $this.ItemEffect.Prefix.Coordinates.Column
            }
            Write-Host "$($this.LineBlankActual.ToAnsiControlSequenceString())$($this.ItemEffect.ToAnsiControlSequenceString())"
            $this.ItemEffectDirty = $false
        }
    }
    
    [Void]UpdateItemDesc(
        [String]$ItemDesc
    ) {
        $this.ItemDesc.UserData = $ItemDesc
        $this.ItemDescDirty = $true
        $this.Draw()
    }
    
    [Void]UpdateItemEffect(
        [String]$ItemEffect
    ) {
        If($ItemEffect -EQ '') {
            $this.ItemEffect.Prefix.ForegroundColor = [CCTextDefault24]::new()
            $this.ItemEffect.Prefix.Decorations     = [ATDecorationNone]::new()
            $this.ItemEffect.UserData               = 'No Effect'
        } Else {
            $this.ItemEffect.Prefix.ForegroundColor = [CCAppleVMintLight24]::new()
            $this.ItemEffect.Prefix.Decorations     = [ATDecoration]@{
                Blink = $true
                Italic = $true
            }
            $this.ItemEffect.UserData = $ItemEffect
        }
        $this.ItemEffectDirty = $true
        $this.Draw()
    }

    [Void]UpdateAllData(
        [String]$ItemDesc,
        [String]$ItemEffect
    ) {
        $this.UpdateItemDesc($ItemDesc)
        $this.UpdateItemEffect($ItemEffect)
    }
}