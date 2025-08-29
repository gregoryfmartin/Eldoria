using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# PLAYER STATUS MAIN MENU
#
# THIS WINDOW PROVIDES THE MAIN MENU FOR THE PLAYER STATUS SCREEN.
# IT ALLOWS NAVIGATION BETWEEN THE DIFFERENT STATUS SCREENS:
# STATUS, ITEMS, EQUIP, MAGIC, SAVE, AND QUIT.
#
###############################################################################

Class PlayerStatusMainMenu : WindowBase {
    Static [Int]$WindowLTRow    = 1
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowRBRow    = 8
    Static [Int]$WindowRBColumn = 11

    Static [String]$WindowTitle = 'Menu'

    [Int]$ActiveChevronIndex
    
    [List[UIEMenuItem]]$MenuItems

    PlayerStatusMainMenu() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [PlayerStatusMainMenu]::WindowLTRow
            Column = [PlayerStatusMainMenu]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [PlayerStatusMainMenu]::WindowRBRow
            Column = [PlayerStatusMainMenu]::WindowRBColumn
        }

        $this.UpdateDimensions()
        $this.SetupTitle([PlayerStatusMainMenu]::WindowTitle, [CCTextDefault24]::new())

        $this.ActiveChevronIndex = 0
        
        $this.MenuItems = [List[UIEMenuItem]]::new()
        
        $this.InitializeMenuItems()
    }

    [Void]SetActiveChevronColor() {
        $this.MenuItems[$this.ActiveChevronIndex].Prefix.ForegroundColor = [CCAppleVGreenLight24]::new()
    }
    
    [Void]UnsetActiveChevronColor() {
        $this.MenuItems[$this.ActiveChevronIndex].Prefix.ForegroundColor = [CCAppleVGreyDark24]::new()
    }
    
    [Void]InitializeMenuItems() {
        $MenuData = @(
            @{ Label = 'Status'; Action = { $Script:TheStatusScreenState = [StatusScreenState]::Status } },
            @{ Label = 'Items';  Action = { 
                $Script:TheStatusScreenState = [StatusScreenState]::Items
                
                $this.UnsetActiveChevronColor()
                $this.MenuItems[$this.ActiveChevronIndex].Dirty = $true
                $this.Draw()
            } },
            @{ Label = 'Equip';  Action = {} },
            @{ Label = 'Magic';  Action = {} },
            @{ Label = 'Save';   Action = {} },
            @{ Label = 'Quit';   Action = {} }
        )
        
        For([Int]$A = 0; $A -LT $MenuData.Count; $A++) {
            [ATCoordinates]$Pos = [ATCoordinates]@{
                Row    = $this.LeftTop.Row + $A + 1
                Column = $this.LeftTop.Column + 1
            }
            
            [UIEMenuItem]$Item = [UIEMenuItem]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = $Pos
                }
                Action   = $MenuData[$A].Action
            }
            $Item.SetUserData("$($MenuData[$A].Label)")
            
            If($A -EQ 0) {
                $Item.ToggleSelected()
            } Else {
                $Item.Update()
            }
            
            $Item.Dirty = $true
            
            $this.MenuItems.Add($Item)
        }
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()
        
        Foreach($Item in $this.MenuItems) {
            # DRAW CALLS WRITE-HOST ANYWAY, SO THERE'S NO NEED TO CALL IT HERE
            $Item.Draw()
        }
    }
    
    [Void]PlayMoveSound() {
        Try {
            $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
            $Script:TheSfxMPlayer.Play()
        } Catch {
            # DO NOTHING
        }
    }

    [Void]HandleInput() {
        $keyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')
        
        Switch($keyCap.VirtualKeyCode) {
            38 { # UP ARROW
                $this.MenuItems[$this.ActiveChevronIndex].ToggleSelected() # SHOULD SET THE CURRENT ITEM TO FALSE
                $this.ActiveChevronIndex = ($this.ActiveChevronIndex -EQ 0 ? $this.MenuItems.Count - 1 : $this.ActiveChevronIndex - 1)
                $this.MenuItems[$this.ActiveChevronIndex].ToggleSelected() # SHOULD SET THE NEW ITEM TO TRUE
                $this.PlayMoveSound()

                Break
            }

            40 { # DOWN ARROW
                $this.MenuItems[$this.ActiveChevronIndex].ToggleSelected() # SHOULD SET THE CURRENT ITEM TO FALSE
                $this.ActiveChevronIndex = ($this.ActiveChevronIndex -EQ $this.MenuItems.Count - 1 ? 0 : $this.ActiveChevronIndex + 1)
                $this.MenuItems[$this.ActiveChevronIndex].ToggleSelected() # SHOULD SET THE NEW ITEM TO TRUE
                $this.PlayMoveSound()

                Break
            }

            27 { # ESCAPE
                $Script:ThePreviousGlobalGameState = [GameStatePrimary]::PlayerStatusScreen
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen
                $Script:GpsRestoredFromStaBackup   = $false # PERMITS REDRAWS ON SUBSEQUENT VISITS TO THE STATUS SCREEN
                
                Break
            }

            13 { # ENTER
                & $this.MenuItems[$this.ActiveChevronIndex].Action
                
                Break
            }
        }
    }
}
