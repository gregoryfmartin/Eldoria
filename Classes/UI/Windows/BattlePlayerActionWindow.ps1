using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# BATTLE PLAYER ACTION WINDOW
#
###############################################################################

Class BattlePlayerActionWindow : WindowBase {
    Static [Int]$WindowLTRow    = 18
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowRBRow    = 23
    Static [Int]$WindowRBCOlumn = 19

    Static [String]$PlayerChevronCharacter      = '❱'
    Static [String]$PlayerChevronBlankCharacter = ' '
    Static [String]$WindowTitle                 = 'Actions'

    Static [ATString]$PlayerChevron = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCTextDefault24]::new()
        }
        UserData   = "$([BattlePlayerActionWindow]::PlayerChevronCharacter)"
        UseATReset = $true
    }
    Static [ATString]$PlayerChevronBlank = [ATString]@{
        UserData   = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
        UseATReset = $true
    }

    [Int]$ActiveChevronIndex
    [Boolean]$PlayerChevronDirty
    [Boolean]$ActiveItemBlinking
    [Boolean]$ActionADrawDirty
    [Boolean]$ActionBDrawDirty
    [Boolean]$ActionCDrawDirty
    [Boolean]$ActionDDrawDirty
    [ATCoordinates]$ActionADrawCoords
    [ATCoordinates]$ActionBDrawCoords
    [ATCoordinates]$ActionCDrawCoords
    [ATCoordinates]$ActionDDrawCoords
    [List[ValueTuple[[ATString], [Boolean]]]]$Chevrons

    BattlePlayerActionWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [BattlePlayerActionWindow]::WindowLTRow
            Column = [BattlePlayerActionWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [BattlePlayerActionWindow]::WindowRBRow
            Column = [BattlePlayerActionWindow]::WindowRBColumn
        }

        $this.UpdateDimensions()

        $this.SetupTitle([BattlePlayerActionWindow]::WindowTitle, [CCTextDefault24]::new())

        $this.ActiveChevronIndex = 0
        $this.PlayerChevronDirty = $true
        $this.ActiveItemBlinking = $false
        $this.ActionADrawDirty   = $true
        $this.ActionBDrawDirty   = $true
        $this.ActionCDrawDirty   = $true
        $this.ActionDDrawDirty   = $true
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
    }

    [Void]CreateChevrons() {
        $this.Chevrons = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionADrawCoords.Row
                            Column = $this.ActionADrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([BattlePlayerActionWindow]::PlayerChevronCharacter)"
                    UseATReset = $true
                },
                $true
            )
        )
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionBDrawCoords.Row
                            Column = $this.ActionBDrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
                    UseATReset = $true
                },
                $false
            )
        )
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionCDrawCoords.Row
                            Column = $this.ActionCDrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
                    UseATReset = $true
                },
                $false
            )
        )
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionDDrawCoords.Row
                            Column = $this.ActionDDrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
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
        $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
        $this.ActiveChevronIndex                                = 0
        $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
        $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronCharacter)"
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.ActionADrawDirty -EQ $true) {
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
            Write-Host "$($a.ToAnsiControlSequenceString())"
            $this.ActionADrawDirty = $false
        }
        If($this.ActionBDrawDirty -EQ $true) {
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
            Write-Host "$($a.ToAnsiControlSequenceString())"
            $this.ActionBDrawDirty = $false
        }
        If($this.ActionCDrawDirty -EQ $true) {
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
            Write-Host "$($a.ToAnsiControlSequenceString())"
            $this.ActionCDrawDirty = $false
        }
        If($this.ActionDDrawDirty -EQ $true) {
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
            Write-Host "$($a.ToAnsiControlSequenceString())"
            $this.ActionDDrawDirty = $false
        }
        If($this.PlayerChevronDirty -EQ $true) {
            Foreach($c in $this.Chevrons) {
                Write-Host "$($c.Item1.ToAnsiControlSequenceString())"
            }
            $this.PlayerChevronDirty = $false
        }
    }

    [BattleAction]HandleInput() {
        $keyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')
        Switch($keyCap.VirtualKeyCode) {
            13 {
                Switch($this.ActiveChevronIndex) {
                    0 {
                        If(($Script:ThePlayer.ActionListing[[ActionSlot]::A].MpCost -GT 0) -AND ($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base -LT $Script:ThePlayer.ActionListing[[ActionSlot]::A].MpCost)) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBattleNem)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteNotEnoughMpMessage()
                            $Script:TheBattleStatusMessageWindow.Draw()

                            Return $null
                        }

                        Return $Script:ThePlayer.ActionListing[[ActionSlot]::A]
                    }

                    1 {
                        If(($Script:ThePlayer.ActionListing[[ActionSlot]::B].MpCost -GT 0) -AND ($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base -LT $Script:ThePlayer.ActionListing[[ActionSlot]::B].MpCost)) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBattleNem)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteNotEnoughMpMessage()
                            $Script:TheBattleStatusMessageWindow.Draw()

                            Return $null
                        }

                        Return $Script:ThePlayer.ActionListing[[ActionSlot]::B]
                    }

                    2 {
                        If(($Script:ThePlayer.ActionListing[[ActionSlot]::C].MpCost -GT 0) -AND ($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base -LT $Script:ThePlayer.ActionListing[[ActionSlot]::C].MpCost)) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBattleNem)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteNotEnoughMpMessage()
                            $Script:TheBattleStatusMessageWindow.Draw()

                            Return $null
                        }

                        Return $Script:ThePlayer.ActionListing[[ActionSlot]::C]
                    }

                    3 {
                        If(($Script:ThePlayer.ActionListing[[ActionSlot]::D].MpCost -GT 0) -AND ($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base -LT $Script:ThePlayer.ActionListing[[ActionSlot]::D].MpCost)) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBattleNem)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteNotEnoughMpMessage()
                            $Script:TheBattleStatusMessageWindow.Draw()

                            Return $null
                        }

                        Return $Script:ThePlayer.ActionListing[[ActionSlot]::D]
                    }

                    Default {
                        Return $null
                    }
                }
            }

            38 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    # Write-Host 'Blew up'
                }
                If(($this.ActiveChevronIndex - 1) -LT 0) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex                                = 3
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronCharacter)"
                } Elseif(($this.ActiveChevronIndex - 1) -GE 0) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex--
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronCharacter)"
                }
                $this.PlayerChevronDirty = $true
            }

            40 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    # Write-Host 'Blew up'
                }
                If(($this.ActiveChevronIndex + 1) -GT 3) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex                                = 0
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronCharacter)"
                } Elseif(($this.ActiveChevronIndex + 1) -LE 3) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex++
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronCharacter)"
                }
                $this.PlayerChevronDirty = $true
            }
        }

        Return $null
    }

    [Void]SetAllActionDrawDirty() {
        $this.ActionADrawDirty = $true
        $this.ActionBDrawDirty = $true
        $this.ActionCDrawDirty = $true
        $this.ActionDDrawDirty = $true
    }
}
