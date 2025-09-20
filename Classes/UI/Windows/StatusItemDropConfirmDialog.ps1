using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# STATUS ITEM DROP CONFIRM DIALOG
#
# A DIALOG THAT ASKS THE USER TO CONFIRM THEY WANT TO DROP AN ITEM.
#
###############################################################################

Class StatusItemDropConfirmDialog : WindowBase {
    Static [Int]$WindowLTRow    = 9
    Static [Int]$WindowLTColumn = 15
    Static [Int]$WindowRBRow    = 13
    Static [Int]$WindowRBColumn = 65

    Static [String]$WindowTitle = 'Drop?'
    Static [String]$BgData      = ' ' * ([StatusItemDropConfirmDialog]::WindowRBColumn - [StatusItemDropConfirmDialog]::WindowLTColumn)

    # [MapTileObject]$ItemToDrop

    [ATString]$BgActual

    [ATStringComposite]$PromptLineActual
    [ATStringComposite]$ActionLineActual

    [Boolean]$BgDirty
    [Boolean]$DataDirty

    StatusItemDropConfirmDialog() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [StatusItemDropConfirmDialog]::WindowLTRow
            Column = [StatusItemDropConfirmDialog]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [StatusItemDropConfirmDialog]::WindowRBRow
            Column = [StatusItemDropConfirmDialog]::WindowRBColumn
        }

        $this.UpdateDimensions()
        $this.SetupTitle([StatusItemDropConfirmDialog]::WindowTitle, [CCTextDefault24]::new())

        $this.BgDirty   = $true
        $this.DataDirty = $true

        $this.BgActual = [ATString]@{
            Prefix = [ATStringPrefix]@{
                Coordinates = [ATCoordinates]@{
                    Row    = $this.LeftTop.Row
                    Column = $this.LeftTop.Column
                }
            }
            UserData   = "$([StatusItemDropConfirmDialog]::BgData)"
            UseATReset = $true
        }

        $this.SetupPromptLine()
        $this.SetupActionLine()
    }

    [Void]Draw() {
        If($this.BgDirty -EQ $true) {
            For([Int]$I = $this.LeftTop.Row; $I -LE $this.RightBottom.Row; $I++) {
                $this.BgActual.Prefix.Coordinates.Row = $I
                Write-Host "$($this.BgActual.ToAnsiControlSequenceString())"
            }
            $this.BgDirty = $false
        }

        ([WindowBase]$this).Draw()

        If($this.DataDirty -EQ $true) {
            $this.SetupPromptLine()
            $this.SetupActionLine()
            
            Write-Host "$($this.PromptLineActual.ToAnsiControlSequenceString())$($this.ActionLineActual.ToAnsiControlSequenceString())"

            $this.DataDirty = $false
        }
    }

    [Void]HandleInput() {
        $KeyCap = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')

        Switch($KeyCap.VirtualKeyCode) {
            13 { # ENTER
                # This is where the item drop logic would go.
                # For now, we'll just remove the item from the player's inventory.
                $ItemToRemove = $null
                foreach ($ItemTuple in $Script:ThePlayer.ItemInventory) {
                    if ($ItemTuple.Item1.MapObjName -EQ $Script:TheItemToDrop.MapObjName) {
                        $ItemToRemove = $ItemTuple
                        
                        Break
                    }
                }
                If($null -NE $ItemToRemove) {
                    $Script:ThePlayer.ItemInventory.RemoveAllItem($ItemToRemove.Item1)
                }

                # $Script:TheBufferManager.RestoreBufferBToActive()
                
                $Script:TheStatusScreenState                          = [StatusScreenState]::Items
                $Script:TheStatusItemInventoryWindow.BookDirty        = $true
                $Script:TheStatusItemInventoryWindow.CurrentPageDirty = $true
                
                # $Script:TheStatusItemInventoryWindow.SetAllDirty()
                # $Script:TheStatusItemHeaderWindow.SetAllDirty()
                $Script:TheStatusItemInventoryWindow.Draw()
                $Script:TheStatusItemHeaderWindow.Draw()
                
                Break
            }
            
            27 { # ESCAPE
                $Script:TheItemToDrop = $null
                # $Script:TheBufferManager.RestoreBufferBToActive()
                $Script:TheStatusScreenState = [StatusScreenState]::Items

                $Script:TheStatusItemInventoryWindow.SetListDirty(); $Script:TheStatusItemInventoryWindow.Draw()
                $Script:TheStatusItemHeaderWindow.Draw()
                
                Break
            }
            
            Default {
                Break
            }
        }
    }

    [Void]SetupPromptLine() {
        $this.PromptLineActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 1
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData   = 'Do you want to drop '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVYellowLight24]::new()
                    Decorations     = [ATDecoration]@{ Blink = $true }
                }
                UserData   = "$($Script:TheItemToDrop.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = '?'
                UseATReset = $true
            }
        ))
    }

    [Void]SetupActionLine() {
        $this.ActionLineActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 3
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData   = 'Press '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVYellowLight24]::new()
                    Decorations     = [ATDecoration]@{ Blink = $true }
                }
                UserData   = 'Enter'
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' to drop or '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVYellowLight24]::new()
                    Decorations     = [ATDecoration]@{ Blink = $true }
                }
                UserData   = 'Escape'
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' to cancel.'
                UseATReset = $true
            }
        ))
    }

    [Void]SetAllDirty() {
        $this.BgDirty   = $true
        $this.DataDirty = $true
        $this.BorderDrawDirty = [Boolean[]]@(
            $true,
            $true,
            $true,
            $true
        )
        $this.TitleDirty = $true
    }
}