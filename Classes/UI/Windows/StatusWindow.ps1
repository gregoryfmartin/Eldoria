using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# STATUS WINDOW
#
# USED IN THE WORLD NAVIGATION STATE/SCREEN, THIS WINDOW SHOWS VERY BASIC
# STATISTICS ABOUT THE PLAYER. THE NAME OF THIS OBJECT SHOULD REALLY BE 
# CHANGED TO BETTER REFLECT ITS INTENDED USE. THIS NAME IS A VESTIGE FROM THE
# ORIGINAL CODE BASE.
#
# THIS CODE HAS ALSO BEEN DRAMATICALLY SIMPLIFIED FROM ITS ORIGINAL DESIGN.
# ONE OF THE MAJOR COMPONENTS THAT'S BEEN REMOVED IS CROSS PLATFORM SUPPORT
# IN THE DRAW METHOD. THIS VESTIGE IS NO LONGER NECESSARY SINCE THE CODE WILL
# NO LONGER BE PORTABLE BY DESIGN.
#
###############################################################################

Class StatusWindow : WindowBase {
    Static [Int]$PlayerStatDrawColumn = 3
    Static [Int]$PlayerNameDrawRow    = 2
    Static [Int]$PlayerHpDrawRow      = 4
    Static [Int]$PlayerMpDrawRow      = 6
    Static [Int]$PlayerGoldDrawRow    = 9
    Static [Int]$WindowLTRow          = 1
    Static [Int]$WindowLTColumn       = 1
    Static [Int]$WindowRBRow          = 10
    Static [Int]$WindowRBColumn       = 19

    Static [String]$LineBlank   = '                '
    Static [String]$WindowTitle = 'Status'

    Static [ATCoordinates]$PlayerNameDrawCoordinates = [ATCoordinates]::new([StatusWindow]::PlayerNameDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerHpDrawCoordinates   = [ATCoordinates]::new([StatusWindow]::PlayerHpDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerMpDrawCoordinates   = [ATCoordinates]::new([StatusWindow]::PlayerMpDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerGoldDrawCoordinates = [ATCoordinates]::new([StatusWindow]::PlayerGoldDrawRow, [StatusWindow]::PlayerStatDrawColumn)

    [Boolean]$PlayerNameDrawDirty
    [Boolean]$PlayerHpDrawDirty
    [Boolean]$PlayerMpDrawDirty
    [Boolean]$PlayerGoldDrawDirty

    [ATString]$LineBlankActual

    StatusWindow() : base() {
        $this.LeftTop          = [ATCoordinates]::new([StatusWindow]::WindowLTRow, [StatusWindow]::WindowLTColumn)
        $this.RightBottom      = [ATCoordinates]::new([StatusWindow]::WindowRBRow, [StatusWindow]::WindowRBColumn)

        $this.UpdateDimensions()
        $this.SetupTitle([StatusWindow]::WindowTitle, [CCTextDefault24]::new())

        $this.PlayerNameDrawDirty = $true
        $this.PlayerHpDrawDirty   = $true
        $this.PlayerMpDrawDirty   = $true
        $this.PlayerGoldDrawDirty = $true
        $this.LineBlankActual     = [ATString]@{
            Prefix = [ATStringPrefix]@{
                Coordinates = [ATCoordinates]::new()
            }
            UserData   = "$([StatusWindow]::LineBlank)"
            UseATReset = $true
        }
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.PlayerNameDrawDirty -EQ $true) {
            [ATString]$A = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:ThePlayer.NameDrawColor
                    Coordinates     = [StatusWindow]::PlayerNameDrawCoordinates
                }
                UserData   = $Script:ThePlayer.Name
                UseATReset = $true
            }
            $this.LineBlankActual.Prefix.Coordinates = [StatusWindow]::PlayerNameDrawCoordinates
            Write-Host "$($this.LineBlankActual.ToAnsiControlSequenceString())$($A.ToAnsiControlSequenceString())"
            $this.PlayerNameDrawDirty = $false
        }

        If($this.PlayerHpDrawDirty -EQ $true) {
            [String]$A               = ''
            [ATStringComposite]$Line = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [StatusWindow]::PlayerHpDrawCoordinates
                    }
                    UserData = 'H '
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe
                    }
                    UserData = "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Base)`n`t"
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData = '/ '
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe
                    }
                    UserData   = "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Max)"
                    UseATReset = $true
                }
            ))

            Switch($Script:ThePlayer.Stats[[StatId]::HitPoints].State) {
                ([StatNumberState]::Normal) {
                    $A += "$($Line.ToAnsiControlSequenceString())"

                    Break
                }

                ([StatNumberState]::Caution) {
                    $Line.CompositeActual[1].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorCaution
                    $Line.CompositeActual[3].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorCaution
                    $A += "$($Line.ToAnsiControlSequenceString())"

                    Break
                }

                ([StatNumberState]::Danger) {
                    $Line.CompositeActual[1].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorDanger
                    $Line.CompositeActual[3].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorDanger
                    $A += "$($Line.ToAnsiControlSequenceString())"

                    Break
                }

                Default {
                    $A += "$($Line.ToAnsiControlSequenceString())"

                    Break
                }
            }

            ###################################################################
            #
            # MAKE A FUCKING MENTAL NOTE THAT THIS IS ABSOLUTELY NECESSARY!!!
            #
            # I TOTALLY FORGOT WHY I NEEDED THIS, AND NOW I REMEMBER!
            #
            # IF LINEBLANKACTUAL.PREFIX.COORDINATES IS ASSIGNED TO PLAYERHPDRAWCOORDINATES,
            # THE STATEMENT THAT POSTFIXES THE ROW VALUE WILL MODIFY PLAYERHPDRAWCOORDINATES
            # AND CAUSE SUBSEQUENT DRAWS TO TRAIL DOWN THE SCREEN, WHICH IS TOTAL BULLSHIT!!!
            # IMPLICIT COPY IS TOO MUCH TO ASK EVIDENTLY.
            #
            ###################################################################
            $this.LineBlankActual.Prefix.Coordinates = [ATCoordinates]::new([StatusWindow]::PlayerHpDrawCoordinates)
            Write-Host "$($this.LineBlankActual.ToAnsiControlSequenceString())"
            $this.LineBlankActual.Prefix.Coordinates.Row++
            Write-Host "$($this.LineBlankActual.ToAnsiControlSequenceString())$($A)"
            $this.PlayerHpDrawDirty = $false
        }

        If($this.PlayerMpDrawDirty -EQ $true) {
            [String]$A = ''
            [ATStringComposite]$Line = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [StatusWindow]::PlayerMpDrawCoordinates
                    }
                    UserData = 'M '
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe
                    }
                    UserData = "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base)`n`t"
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData = '/ '
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe
                    }
                    UserData   = "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Max)"
                    UseATReset = $true
                }
            ))

            Switch($Script:ThePlayer.Stats[[StatId]::MagicPoints].State) {
                ([StatNumberState]::Normal) {
                    $A += "$($Line.ToAnsiControlSequenceString())"

                    Break
                }

                ([StatNumberState]::Caution) {
                    $Line.CompositeActual[1].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorCaution
                    $Line.CompositeActual[3].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorCaution
                    $A += "$($Line.ToAnsiControlSequenceString())"

                    Break
                }

                ([StatNumberState]::Danger) {
                    $Line.CompositeActual[1].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorDanger
                    $Line.CompositeActual[3].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorDanger
                    $A += "$($Line.ToAnsiControlSequenceString())"

                    Break
                }

                Default {
                    $A += "$($Line.ToAnsiControlSequenceString())"

                    Break
                }
            }

            $this.LineBlankActual.Prefix.Coordinates = [ATCoordinates]::new([StatusWindow]::PlayerMpDrawCoordinates)
            Write-Host "$($this.LineBlankActual.ToAnsiControlSequenceString())"
            $this.LineBlankActual.Prefix.Coordinates.Row++
            Write-Host "$($this.LineBlankActual.ToAnsiControlSequenceString())$($a)"
            $this.PlayerMpDrawDirty = $false
        }

        If($this.PlayerGoldDrawDirty -EQ $true) {
            [ATStringComposite]$Line = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [Player]::GoldDrawColor
                        Coordinates     = [StatusWindow]::PlayerGoldDrawCoordinates
                    }
                    UserData = "$($Script:ThePlayer.CurrentGold)"
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = 'G'
                    UseATReset = $true
                }
            ))

            $this.LineBlankActual.Prefix.Coordinates = [ATCoordinates]::new([StatusWindow]::PlayerGoldDrawCoordinates)
            Write-Host "$($this.LineBlankActual.ToAnsiControlSequenceString())$($Line.ToAnsiControlSequenceString())"
            $this.PlayerGoldDrawDirty = $false
        }
    }
}

