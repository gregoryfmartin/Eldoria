using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# STATUS TECHNIQUE SELECTION WINDOW
#
###############################################################################

Class StatusTechniqueSelectionWindow : WindowBase {
    Static [Int]$WindowLTRow    = 4
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowRBRow    = 9
    Static [Int]$WindowRBColumn = 19

    Static [String]$PlayerChevronCharacter      = '❱'
    Static [String]$PlayerChevronBlankCharacter = ' '
    Static [String]$NameBlank                   = '              '
    Static [String]$WindowTitle                 = 'Equipped'

    Static [ATString]$PlayerChevron = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCTextDefault24]::new()
        }
        UserData   = "$([StatusTechniqueSelectionWindow]::PlayerChevronCharacter)"
        UseATReset = $true
    }
    Static [ATString]$PlayerChevronBlank = [ATString]@{
        UserData   = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
        UseATReset = $true
    }
    Static [ATString]$BaNameBlank = [ATString]@{
        Prefix     = [ATStringPrefix]::new()
        UserData   = "$([StatusTechniqueSelectionWindow]::NameBlank)"
        UseATReset = $true
    }

    [Int]$ActiveChevronIndex
    [Boolean]$PlayerChevronDirty
    [Boolean]$ActiveItemBlinking
    [Boolean]$ActionADrawDirty
    [Boolean]$ActionBDrawDirty
    [Boolean]$ActionCDrawDirty
    [Boolean]$ActionDDrawDirty
    [Boolean]$IsActive
    [ATCoordinates]$ActionADrawCoords
    [ATCoordinates]$ActionBDrawCoords
    [ATCoordinates]$ActionCDrawCoords
    [ATCoordinates]$ActionDDrawCoords
    [List[ValueTuple[[ATString], [Boolean]]]]$Chevrons

    StatusTechniqueSelectionWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [StatusTechniqueSelectionWindow]::WindowLTRow
            Column = [StatusTechniqueSelectionWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [StatusTechniqueSelectionWindow]::WindowRBRow
            Column = [StatusTechniqueSelectionWindow]::WindowRBColumn
        }

        $this.UpdateDimensions()

        $this.ActiveChevronIndex = 0
        $this.PlayerChevronDirty = $true
        $this.ActiveItemBlinking = $false
        $this.ActionADrawDirty   = $true
        $this.ActionBDrawDirty   = $true
        $this.ActionCDrawDirty   = $true
        $this.ActionDDrawDirty   = $true
        $this.IsActive           = $true
        $this.ActionADrawCoords = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 1
            Column = $this.LeftTop.Column + 3
        }
        $this.ActionBDrawCoords = [ATCoordinates]@{
            Row    = $this.ActionADrawCoords.Row + 1
            Column = $this.ActionADrawCoords.Column
        }
        $this.ActionCDrawCoords = [ATCoordinates]@{
            Row    = $this.ActionBDrawCoords.Row + 1
            Column = $this.ActionBDrawCoords.Column
        }
        $this.ActionDDrawCoords = [ATCoordinates]@{
            Row    = $this.ActionCDrawCoords.Row + 1
            Column = $this.ActionCDrawCoords.Column
        }
        $this.CreateChevrons()

        $this.SetupTitle([StatusTechniqueSelectionWindow]::WindowTitle, [CCTextDefault24]::new())
    }

    [Void]CreateChevrons() {
        $this.Chevrons = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAPpleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionADrawCoords.Row
                            Column = $this.ActionADrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([StatusTechniqueSelectionWindow]::PlayerChevronCharacter)"
                    UseATReset = $true
                },
                $true
            )
        )
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAPpleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionBDrawCoords.Row
                            Column = $this.ActionBDrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
                    UseATReset = $true
                },
                $false
            )
        )
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAPpleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionCDrawCoords.Row
                            Column = $this.ActionCDrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
                    UseATReset = $true
                },
                $false
            )
        )
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAPpleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionDDrawCoords.Row
                            Column = $this.ActionDDrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
                    UseATReset = $true
                },
                $false
            )
        )
    }

    [ATString]GetActiveChevron() {
        Foreach($a in $this.Chevrons) {
            If($a.Item2 -EQ $true) {
                Return $a.Item1
            }
        }
        $this.ActiveChevronIndex                       = 0
        $this.Chevrons[$this.ActiveChevronIndex].Item2 = $true

        Return $this.Chevrons[$this.ActiveChevronIndex].Item1
    }

    [Void]ResetChevronPosition() {
        $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
        $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
        $this.ActiveChevronIndex                                = 0
        $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
        $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronCharacter)"
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.ActionADrawDirty -EQ $true) {
            [StatusTechniqueSelectionWindow]::BaNameBlank.Prefix.Coordinates = [ATCoordinates]@{
                Row    = $this.ActionADrawCoords.Row
                Column = $this.ActionADrawCoords.Column + 1
            }
            [ATStringComposite]$a = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::A].Type].Item2
                        Coordinates     = $this.ActionADrawCoords
                    }
                    UserData   = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::A].Type].Item1)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = " $($Script:ThePlayer.ActionListing[[ActionSlot]::A].Name)"
                    UseATReset = $true
                }
            ))
            Write-Host "$([StatusTechniqueSelectionWindow]::BaNameBlank.ToAnsiControlSequenceString())$($a.ToAnsiControlSequenceString())"
            $this.ActionADrawDirty = $false
        }
        If($this.ActionBDrawDirty -EQ $true) {
            [StatusTechniqueSelectionWindow]::BaNameBlank.Prefix.Coordinates = [ATCoordinates]@{
                Row    = $this.ActionBDrawCoords.Row
                Column = $this.ActionBDrawCoords.Column + 1
            }
            [ATStringComposite]$a = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::B].Type].Item2
                        Coordinates     = $this.ActionBDrawCoords
                    }
                    UserData   = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::B].Type].Item1)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = " $($Script:ThePlayer.ActionListing[[ActionSlot]::B].Name)"
                    UseATReset = $true
                }
            ))
            Write-Host "$([StatusTechniqueSelectionWindow]::BaNameBlank.ToAnsiControlSequenceString())$($a.ToAnsiControlSequenceString())"
            $this.ActionBDrawDirty = $false
        }
        If($this.ActionCDrawDirty -EQ $true) {
            [StatusTechniqueSelectionWindow]::BaNameBlank.Prefix.Coordinates = [ATCoordinates]@{
                Row    = $this.ActionCDrawCoords.Row
                Column = $this.ActionCDrawCoords.Column + 1
            }
            [ATStringComposite]$a = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::C].Type].Item2
                        Coordinates     = $this.ActionCDrawCoords
                    }
                    UserData   = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::C].Type].Item1)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = " $($Script:ThePlayer.ActionListing[[ActionSlot]::C].Name)"
                    UseATReset = $true
                }
            ))
            Write-Host "$([StatusTechniqueSelectionWindow]::BaNameBlank.ToAnsiControlSequenceString())$($a.ToAnsiControlSequenceString())"
            $this.ActionCDrawDirty = $false
        }
        If($this.ActionDDrawDirty -EQ $true) {
            [StatusTechniqueSelectionWindow]::BaNameBlank.Prefix.Coordinates = [ATCoordinates]@{
                Row    = $this.ActionDDrawCoords.Row
                Column = $this.ActionDDrawCoords.Column + 1
            }
            [ATStringComposite]$a = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::D].Type].Item2
                        Coordinates     = $this.ActionDDrawCoords
                    }
                    UserData   = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::D].Type].Item1)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = " $($Script:ThePlayer.ActionListing[[ActionSlot]::D].Name)"
                    UseATReset = $true
                }
            ))
            Write-Host "$([StatusTechniqueSelectionWindow]::BaNameBlank.ToAnsiControlSequenceString())$($a.ToAnsiControlSequenceString())"
            $this.ActionDDrawDirty = $false
        }
        If($this.PlayerChevronDirty -EQ $true) {
            If($this.IsActive -EQ $true) {
                Foreach($c in $this.Chevrons) {
                    $c.Item1.Prefix.ForegroundColor = [CCAppleNGreenLight24]::new()
                    Write-Host "$($c.Item1.ToAnsiControlSequenceString())"
                }
            } Else {
                Foreach($c in $this.Chevrons) {
                    $c.Item1.Prefix.ForegroundColor = [CCAppleNOrangeLight24]::new()
                    Write-Host "$($c.Item1.ToAnsiControlSequenceString())"
                }
            }
            $this.PlayerChevronDirty = $false
        }
    }

    [Void]HandleInput() {
        $keyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')
        Switch($keyCap.VirtualKeyCode) {
            13 {
                Switch($this.ActiveChevronIndex) {
                    0 {
                        $Script:StatusEsSelectedSlot = [ActionSlot]::A
                    }

                    1 {
                        $Script:StatusEsSelectedSlot = [ActionSlot]::B
                    }

                    2 {
                        $Script:StatusEsSelectedSlot = [ActionSlot]::C
                    }

                    3 {
                        $Script:StatusEsSelectedSlot = [ActionSlot]::D
                    }
                }
                $Script:StatusScreenMode = [StatusScreenMode]::TechInventorySelection
            }

            27 {
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen
            }

            38 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up.'
                }

                If(($this.ActiveChevronIndex - 1) -LT 0) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex                                = 3
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronCharacter)"
                } Elseif(($this.ActiveChevronIndex - 1) -GE 0) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex--
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronCharacter)"
                }
                $this.PlayerChevronDirty = $true
            }

            40 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up'
                }
                If(($this.ActiveChevronIndex + 1) -GT 3) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex                                = 0
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronCharacter)"
                } Elseif(($this.ActiveChevronIndex + 1) -LE 3) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex++
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronCharacter)"
                }
                $this.PlayerChevronDirty = $true
            }
        }
    }

    [Void]SetAllActionDrawDirty() {
        $this.ActionADrawDirty = $true
        $this.ActionBDrawDirty = $true
        $this.ActionCDrawDirty = $true
        $this.ActionDDrawDirty = $true
    }
}

