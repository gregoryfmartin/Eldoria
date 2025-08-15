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

    Static [String]$ChevronCharacter      = '❱'
    Static [String]$ChevronBlankCharacter = ' '

    Static [String[]]$MenuItems = @(
        'Status',
        'Items',
        'Equip',
        'Magic',
        'Save',
        'Quit'
    )

    [Int]$ActiveChevronIndex
    
    [Boolean]$ChevronDirty
    [Boolean]$MenuLabelsDirty
    [Boolean]$CursorHidden
    
    [List[ValueTuple[[ATString], [Boolean]]]]$Chevrons
    [List[ATString]]$MenuLabels

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
        
        $this.ChevronDirty       = $true
        $this.MenuLabelsDirty    = $true
        $this.CursorHidden = $false

        $this.CreateChevrons()
        $this.CreateMenuLabels()
    }

    [Void]CreateChevrons() {
        $this.Chevrons = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        
        For([Int]$i = 0; $i -LT [PlayerStatusMainMenu]::MenuItems.Count; $i++) {
            $this.Chevrons.Add(
                [ValueTuple]::Create(
                    [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                            Coordinates     = [ATCoordinates]@{
                                Row    = $this.LeftTop.Row + $i + 1
                                Column = $this.LeftTop.Column + 1
                            }
                        }
                        UserData   = "$(If($i -EQ 0) { [PlayerStatusMainMenu]::ChevronCharacter } Else { [PlayerStatusMainMenu]::ChevronBlankCharacter })"
                        UseATReset = $true
                    },
                    $($i -EQ 0)
                )
            )
        }
    }

    [Void]CreateMenuLabels() {
        $this.MenuLabels = [List[ATString]]::new()
        
        For([Int]$i = 0; $i -LT [PlayerStatusMainMenu]::MenuItems.Count; $i++) {
            $this.MenuLabels.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row + $i + 1
                            Column = $this.LeftTop.Column + 3
                        }
                    }
                    UserData   = [PlayerStatusMainMenu]::MenuItems[$i]
                    UseATReset = $true
                }
            )
        }
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.ChevronDirty -EQ $true) {
            Foreach($C in $this.Chevrons) {
                Write-Host "$($C.Item1.ToAnsiControlSequenceString())"
            }
            $this.ChevronDirty = $false
        }

        If($this.MenuLabelsDirty -EQ $true) {
            Foreach($L in $this.MenuLabels) {
                Write-Host "$($L.ToAnsiControlSequenceString())"
            }
            $this.MenuLabelsDirty = $false
        }
        
        If($this.CursorHidden -EQ $false) {
            Write-Host "$([ATControlSequences]::CursorHide)"
            $this.CursorHidden = $true
        }
    }

    [Void]HandleInput() {
        $keyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')
        Switch($keyCap.VirtualKeyCode) {
            38 { # UP ARROW
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up'
                }

                If($this.ActiveChevronIndex -EQ 0) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = [PlayerStatusMainMenu]::ChevronBlankCharacter
                    $this.ActiveChevronIndex                                = [PlayerStatusMainMenu]::MenuItems.Count - 1
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = [PlayerStatusMainMenu]::ChevronCharacter
                } Elseif(($this.ActiveChevronIndex - 1) -GE 0) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = [PlayerStatusMainMenu]::ChevronBlankCharacter
                    $this.ActiveChevronIndex--
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = [PlayerStatusMainMenu]::ChevronCharacter
                }
                $this.ChevronDirty = $true

                Break
            }

            40 { # DOWN ARROW
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up'
                }

                If(($this.ActiveChevronIndex + 1) -GE [PlayerStatusMainMenu]::MenuItems.Count) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = [PlayerStatusMainMenu]::ChevronBlankCharacter
                    $this.ActiveChevronIndex                                = 0
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = [PlayerStatusMainMenu]::ChevronCharacter
                } Elseif(($this.ActiveChevronIndex + 1) -LT [PlayerStatusMainMenu]::MenuItems.Count) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = [PlayerStatusMainMenu]::ChevronBlankCharacter
                    $this.ActiveChevronIndex++
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = [PlayerStatusMainMenu]::ChevronCharacter
                }
                $this.ChevronDirty = $true

                Break
            }

            27 { # ESCAPE
                $Script:ThePreviousGlobalGameState = [GameStatePrimary]::PlayerStatusScreen
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen
                $Script:GpsRestoredFromStaBackup   = $false # PERMITS REDRAWS ON SUBSEQUENT VISITS TO THE STATUS SCREEN
                
                Break
            }

            13 { # ENTER
                # BASED ON THE CHEVRON INDEX, CHANGE STATE
                Switch($this.ActiveChevronIndex) {
                    0 { # STATUS
                        $Script:TheStatusScreenState = [StatusScreenState]::Status
                        
                        Break
                    }

                    1 { # ITEMS
                        $Script:TheStatusScreenState = [StatusScreenState]::Items

                        Break
                    }
                    
                    Default {
                        Break
                    }
                }
                
                Break
            }
        }
    }
}
