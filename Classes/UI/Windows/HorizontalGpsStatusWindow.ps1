using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# HORIZONTAL GPS STATUS WINDOW
#
# A NEW WINDOW USED IN THE NAVIGATION SCREEN. THIS WINDOW DOES THE SAME EXACT
# THING THAT THE LEGACY STATUS WINDOW DID, JUST DISPLAYED IN A HORIZONTAL
# FASHION. IT ALSO TRIMS OFF SOME DATA TO MAKE IT MORE STREAMLINED.
#
###############################################################################

Class HorizontalGpsStatusWindow : WindowBase {
    Static [Int]$PlayerStatDrawColumn = 3
    Static [Int]$PlayerStatDrawRow    = 2
    Static [Int]$WindowLTRow          = 1
    Static [Int]$WindowLTColumn       = 1
    Static [Int]$WindowRBRow          = 3
    Static [Int]$WindowRBColumn       = 80

    Static [String]$WindowTitle = 'Status'

    [UIELabel[]]$Labels

    [Boolean]$AreLabelsSetup

    HorizontalGpsStatusWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [HorizontalGpsStatusWindow]::WindowLTRow
            Column = [HorizontalGpsStatusWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [HorizontalGpsStatusWindow]::WindowRBRow
            Column = [HorizontalGpsStatusWindow]::WindowRBColumn
        }

        $this.UpdateDimensions()
        $this.SetupTitle(
            [HorizontalGpsStatusWindow]::WindowTitle,
            [CCTextDefault24]::new()
        )

        $this.AreLabelsSetup = $false
    }

    [Void]SetupLabels() {
        If($this.AreLabelsSetup -EQ $false) {
            $this.Labels = @(
                [UIELabel]@{ # PLAYER'S NAME
                    Prefix = [ATStringPrefix]@{
                        Coordinates = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row + 1
                            Column = $this.LeftTop.Column + 2
                        }
                    }
                    UseATReset = $true
                    Dirty      = $true
                },
                [UIELabel]@{ # HP 'H' SYMBOL
                    Prefix = [ATStringPrefix]@{
                        Coordinates = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row + 1
                            Column = ($this.Width / 2) + 4
                        }
                    }
                    UseATReset = $true
                    Dirty      = $true
                },
                [UIELabel]@{ # HP BASE NUMBER (9999)
                    Prefix = [ATStringPrefix]@{
                        Coordinates = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row + 1
                            Column = ($this.Width / 2) + 6
                        }
                    }
                    UseATReset = $true
                    Dirty      = $true
                },
                [UIELabel]@{ # MP 'M' SYMBOL
                    Prefix = [ATStringPrefix]@{
                        Coordinates = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row + 1
                            Column = ($this.Width / 2) + 12
                        }
                    }
                    UseATReset = $true
                    Dirty      = $true
                },
                [UIELabel]@{ # MP BASE NUMBER (9999)
                    Prefix = [ATStringPrefix]@{
                        Coordinates = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row + 1
                            Column = ($this.Width / 2) + 14
                        }
                    }
                    UseATReset = $true
                    Dirty      = $true
                },
                [UIELabel]@{ # GOLD 'G' SYMBOL
                    Prefix = [ATStringPrefix]@{
                        Coordinates = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row + 1
                            Column = ($this.Width / 2) + 20
                        }
                    }
                    UseATReset = $true
                    Dirty      = $true
                },
                [UIELabel]@{ # GOLD NUMBER (9999)
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleYellowLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row + 1
                            Column = ($this.Width / 2) + 22
                        }
                    }
                    UseATReset = $true
                    Dirty      = $true
                }
            )

            $this.Labels[0].SetUserData("$($Script:ThePlayer.Name.PadRight(10))")
            $this.Labels[1].SetUserData('H')
            $this.Labels[3].SetUserData('M')
            $this.Labels[5].SetUserData('G')
            $this.Labels[6].SetUserData("$($Script:ThePlayer.CurrentGold)")

            $this.SetupHpLabel()
            $this.SetupMpLabel()

            $this.AreLabelsSetup = $true
        }
    }

    [Void]SetupHpLabel() {
        Switch($Script:ThePlayer.Stats[[StatId]::HitPoints].State) {
            ([StatNumberState]::Normal) {
                $this.Labels[2].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe

                Break
            }

            ([StatNumberState]::Caution) {
                $this.Labels[2].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorCaution

                Break
            }

            ([StatNumberState]::Danger) {
                $this.Labels[2].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorDanger

                Break
            }

            Default {
                $this.Labels[2].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe

                Break
            }
        }

        $this.Labels[2].SetUserData("$($Script:ThePlayer.Stats[[StatId]::HitPoints].Base)")
    }

    [Void]SetupMpLabel() {
        Switch($Script:ThePlayer.Stats[[StatId]::MagicPoints].State) {
            ([StatNumberState]::Normal) {
                $this.Labels[4].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe

                Break
            }

            ([StatNumberState]::Caution) {
                $this.Labels[4].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorCaution

                Break
            }

            ([StatNumberState]::Danger) {
                $this.Labels[4].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorDanger

                Break
            }

            Default {
                $this.Labels[4].Prefix.ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe

                Break
            }
        }

        $this.Labels[4].SetUserData("$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base)")
    }
    
    [Void]Draw() {
        ([WindowBase]$this).Draw()

        Foreach($Label in $this.Labels) {
            $Label.Draw()
        }
    }
}