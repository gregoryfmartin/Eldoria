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

    [UIEMenu]$Menu

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

        $this.Menu = [UIEMenu]::new(
            @(
                @{ Label = 'Status'; Action = { $Script:TheStatusScreenState = [StatusScreenState]::Status } },
                @{ Label = 'Items';  Action = { 
                    $Script:TheStatusScreenState = [StatusScreenState]::Items
                
                    $Script:ThePlayerStatusMainMenu.Menu.UnsetActiveColored()
                    $Script:ThePlayerStatusMainMenu.Draw()
                } },
                @{ Label = 'Equip';  Action = {} },
                @{ Label = 'Magic';  Action = {} },
                @{ Label = 'Save';   Action = {} },
                @{ Label = 'Quit';   Action = {} }
            ),
            $this.LeftTop
        )
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()
        
        $this.Menu.Draw()
    }
    
    [Void]HandleInput() {
        $keyCap = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
        
        Switch($keyCap.VirtualKeyCode) {
            38 { # UP ARROW
                $this.Menu.MoveActiveIndexUp()
                $this.Menu.PlayMoveSound()

                Break
            }

            40 { # DOWN ARROW
                $this.Menu.MoveActiveIndexDown()
                $this.Menu.PlayMoveSound()

                Break
            }

            27 { # ESCAPE
                $Script:ThePreviousGlobalGameState = [GameStatePrimary]::PlayerStatusScreen
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen
                $Script:GpsBufferCleared           = $false
                
                Break
            }

            13 { # ENTER
                $this.Menu.InvokeItemAction()
                
                Break
            }
        }
    }
}
