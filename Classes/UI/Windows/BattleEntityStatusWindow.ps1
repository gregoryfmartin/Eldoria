using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BATTLE ENTITY STATUS WINDOW
#
# THIS IS THE STATUS WINDOW THAT DISPLAYS THE STATUS OF A BATTLE ENTITY IN THE
# BATTLE SCREEN.
#
# BECAUSE IN THE BATTLE SCREEN MULTIPLE INSTANCES OF THIS WINDOW EXIST, THERE
# ARE SOME ANTI-PATTERNS EXHIBITED HERE IN RELATION TO THE OTHER WINDOWS. THE
# FOLLOWING VARIABLES ARE DEMOTED FROM STATIC TO INSTANCE MEMBERS:
#
# WINDOWLTROW
# WINDOWLTCOLUMN
# WINDOWRBROW
# WINDOWRBCOLUMN
#
###############################################################################

Class BattleEntityStatusWindow : WindowBase {
    Static [String]$FullLineBlankActual    = '                '

    [ATCoordinates]$HpDrawCoordinates
    [ATCoordinates]$MpDrawCoordinates
    [ATCoordinates]$StatL1DrawCoordinates
    [ATCoordinates]$StatL2DrawCoordinates
    [ATCoordinates]$StatL3DrawCoordinates
    [ATCoordinates]$StatL4DrawCoordinates
    [Int]$WindowLTRow
    [Int]$WindowLTColumn
    [Int]$WindowRBRow
    [Int]$WindowRBColumn
    [Boolean]$HpDrawDirty
    [Boolean]$MpDrawDirty
    [Boolean]$StatL1DrawDirty
    [Boolean]$StatL2DrawDirty
    [Boolean]$StatL3DrawDirty
    [Boolean]$StatL4DrawDirty
    [Boolean]$EntityBattlePhaseActive
    [Boolean]$HasSetEntityActive
    [ATString]$FullLineBlank
    [ATStringComposite]$HpDrawString
    [ATStringComposite]$MpDrawString
    [ATStringComposite]$StatL1DrawString
    [ATStringComposite]$StatL2DrawString
    [ATStringComposite]$StatL3DrawString
    [ATStringComposite]$StatL4DrawString
    [BattleEntity]$BERef

    BattleEntityStatusWindow() : base() {
        $this.WindowLTRow    = 1
        $this.WindowLTColumn = 1
        $this.WindowRBRow    = 1
        $this.WindowRBColumn = 1
        $this.LeftTop = [ATCoordinates]@{
            Row    = $this.WindowLTRow
            Column = $this.WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = $this.WindowRBRow
            Column = $this.WindowRBColumn
        }

        $this.UpdateDimensions()

        [Int]$ColDef = $this.LeftTop.Column + 2
        $this.HpDrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 2
            Column = $ColDef
        }
        $this.MpDrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 5
            Column = $ColDef
        }
        $this.StatL1DrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 9
            Column = $ColDef
        }
        $this.StatL2DrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 11
            Column = $ColDef
        }
        $this.StatL3DrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 13
            Column = $ColDef
        }
        $this.StatL4DrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 15
            Column = $ColDef
        }
        $this.HpDrawDirty             = $true
        $this.MpDrawDirty             = $true
        $this.StatL1DrawDirty         = $true
        $this.StatL2DrawDirty         = $true
        $this.StatL3DrawDirty         = $true
        $this.StatL4DrawDirty         = $true
        $this.EntityBattlePhaseActive = $false
        $this.HasSetEntityActive      = $false
        $this.BERef                   = $null
        $this.FullLineBlank           = [ATString]@{
            UserData   = [BattleEntityStatusWindow]::FullLineBlankActual
            UseATReset = $true
        }
    }

    BattleEntityStatusWindow(
        [Int]$WindowLTRow,
        [Int]$WindowLTColumn,
        [Int]$WindowRBRow,
        [Int]$WindowRBColumn,
        [BattleEntity]$BERef
    ) : base() {
        $this.WindowLTRow    = $WindowLTRow
        $this.WindowLTColumn = $WindowLTColumn
        $this.WindowRBRow    = $WindowRBRow
        $this.WindowRBColumn = $WindowRBColumn
        $this.LeftTop = [ATCoordinates]@{
            Row    = $this.WindowLTRow
            Column = $this.WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = $this.WindowRBRow
            Column = $this.WindowRBColumn
        }

        $this.UpdateDimensions()

        [Int]$ColDef = $this.LeftTop.Column + 2
        $this.HpDrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 2
            Column = $ColDef
        }
        $this.MpDrawCoordinates = [ATCoordinates]@{
            Row    = $this.HpDrawCoordinates.Row + 3
            Column = $ColDef
        }
        $this.StatL1DrawCoordinates = [ATCoordinates]@{
            Row    = $this.MpDrawCoordinates.Row + 3
            Column = $ColDef
        }
        $this.StatL2DrawCoordinates = [ATCoordinates]@{
            Row    = $this.StatL1DrawCoordinates.Row + 2
            Column = $ColDef
        }
        $this.StatL3DrawCoordinates = [ATCoordinates]@{
            Row    = $this.StatL2DrawCoordinates.Row + 2
            Column = $ColDef
        }
        $this.StatL4DrawCoordinates = [ATCoordinates]@{
            Row    = $this.StatL3DrawCoordinates.Row + 2
            Column = $ColDef
        }
        $this.HpDrawDirty             = $true
        $this.MpDrawDirty             = $true
        $this.StatL1DrawDirty         = $true
        $this.StatL2DrawDirty         = $true
        $this.StatL3DrawDirty         = $true
        $this.StatL4DrawDirty         = $true
        $this.EntityBattlePhaseActive = $false
        $this.HasSetEntityActive      = $false
        $this.BERef                   = $BERef
        $this.FullLineBlank           = [ATString]@{
            Prefix     = [ATStringPrefix]::new()
            UserData   = [BattleEntityStatusWindow]::FullLineBlankActual
            UseATReset = $true
        }

        $this.SetupTitle("$(
            (
                [ATStringComposite]::new(@(
                    [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = $Script:BATAdornmentCharTable[$this.BERef.Affinity].Item2
                        }
                        UserData   = "$($Script:BATAdornmentCharTable[$this.BERef.Affinity].Item1)"
                        UseATReset = $true
                    },
                    [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = $this.BERef.NameDrawColor
                        }
                        UserData   = " $($this.BERef.Name)"
                        UseATReset = $true
                    }
                ))
            ).ToAnsiControlSequenceString()
        )", $this.BERef.NameDrawColor)
    }

    [Void]Draw() {
        If(($this.EntityBattlePhaseActive -EQ $true) -AND ($this.HasSetEntityActive -EQ $false)) {
            $this.BorderDrawColors = [ConsoleColor24[]](
                [CCAppleYellowDark24]::new(),
                [CCAppleYellowDark24]::new(),
                [CCAppleYellowDark24]::new(),
                [CCAppleYellowDark24]::new(),
                [CCAppleYellowDark24]::new(),
                [CCAppleYellowDark24]::new(),
                [CCAppleYellowDark24]::new(),
                [CCAppleYellowDark24]::new()
            )
            $this.BorderDrawDirty = [Boolean[]](
                $true,
                $true,
                $true,
                $true,
                $true,
                $true,
                $true,
                $true
            )
            $this.HasSetEntityActive = $true
            $this.TitleDirty         = $true
        } Elseif($this.EntityBattlePhaseActive -EQ $false) {
            $this.BorderDrawColors = [ConsoleColor24[]](
                [CCWindowBorderDefault24]::new(),
                [CCWindowBorderDefault24]::new(),
                [CCWindowBorderDefault24]::new(),
                [CCWindowBorderDefault24]::new(),
                [CCWindowBorderDefault24]::new(),
                [CCWindowBorderDefault24]::new(),
                [CCWindowBorderDefault24]::new(),
                [CCWindowBorderDefault24]::new()
            )
            $this.BorderDrawDirty = [Boolean[]](
                $true,
                $true,
                $true,
                $true,
                $true,
                $true,
                $true,
                $true
            )
            $this.HasSetEntityActive = $false
            $this.TitleDirty         = $true
        }

        ([WindowBase]$this).Draw()
        If($this.HpDrawDirty -EQ $true) {
            $this.CreateHpDrawString()
            $this.FullLineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.HpDrawCoordinates)
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())"
            $this.FullLineBlank.Prefix.Coordinates.Row++
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.HpDrawString.ToAnsiControlSequenceString())"
            $this.HpDrawDirty = $false
        }
        If($this.MpDrawDirty -EQ $true) {
            $this.CreateMpDrawString()
            $this.FullLineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.MpDrawCoordinates)
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.MpDrawString.ToAnsiControlSequenceString())"
            $this.MpDrawDirty = $false
        }
        If($this.StatL1DrawDirty -EQ $true) {
            $this.CreateStatL1DrawString()
            $this.FullLineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.StatL1DrawCoordinates)
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.StatL1DrawString.ToAnsiControlSequenceString())"
            $this.StatL1DrawDirty = $false
        }
        If($this.StatL2DrawDirty -EQ $true) {
            $this.CreateStatL2DrawString()
            $this.FullLineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.StatL2DrawCoordinates)
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.StatL2DrawString.ToAnsiControlSequenceString())"
            $this.StatL2DrawDirty = $false
        }
        If($this.StatL3DrawDirty -EQ $true) {
            $this.CreateStatL3DrawString()
            $this.FullLineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.StatL3DrawCoordinates)
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.StatL3DrawString.ToAnsiControlSequenceString())"
            $this.StatL3DrawDirty = $false
        }
        If($this.StatL4DrawDirty -EQ $true) {
            $this.CreateStatL4DrawString()
            $this.FullLineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.StatL4DrawCoordinates)
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.StatL4DrawString.ToAnsiControlSequenceString())"
            $this.StatL4DrawDirty = $false
        }
    }

    [Void]CreateHpDrawString() {
        [ConsoleColor24]$NumDrawColor = [CCTextDefault24]::new()
        [ATDecoration]$NumDeco        = [ATDecorationNone]::new()

        Switch($this.BERef.Stats[[StatId]::HitPoints].State) {
            ([StatNumberState]::Normal) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorSafe
            }

            ([StatNumberState]::Caution) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorCaution
            }

            ([StatNumberState]::Danger) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorDanger
                $NumDeco      = [ATDecoration]@{
                    Blink = $true
                }
            }

            Default {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorSafe
            }
        }

        $this.HpDrawString = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = $this.HpDrawCoordinates
                }
                UserData = 'H '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $NumDrawColor
                    Decorations     = $NumDeco
                }
                UserData = "$($this.BERef.Stats[[StatId]::HitPoints].Base)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.HpDrawCoordinates.Row + 1
                        Column = $this.HpDrawCoordinates.Column + 6
                    }
                }
                UserData = '/ '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $NumDrawColor
                    Decorations     = $NumDeco
                }
                UserData   = "$($this.BERef.Stats[[StatId]::HitPoints].Max)"
                UseATReset = $true
            }
        ))
    }

    [Void]CreateMpDrawString() {
        [ConsoleColor24]$NumDrawColor = [CCTextDefault24]::new()
        [ATDecoration]$NumDeco        = [ATDecorationNone]::new()

        Switch($this.BERef.Stats[[StatId]::MagicPoints].State) {
            ([StatNumberState]::Normal) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorSafe
            }

            ([StatNumberState]::Caution) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorCaution
            }

            ([StatNumberState]::Danger) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorDanger
                $NumDeco      = [ATDecoration]@{
                    Blink = $true
                }
            }

            Default {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorSafe
            }
        }

        $this.MpDrawString = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = $this.MpDrawCoordinates
                }
                UserData = 'M '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $NumDrawColor
                    Decorations     = $NumDeco
                }
                UserData = "$($this.BERef.Stats[[StatId]::MagicPoints].Base)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.MpDrawCoordinates.Row + 1
                        Column = $this.MpDrawCoordinates.Column + 6
                    }
                }
                UserData = '/ '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $NumDrawColor
                    Decorations     = $NumDeco
                }
                UserData   = "$($this.BERef.Stats[[StatId]::MagicPoints].Max)"
                UseATReset = $true
            }
        ))
    }

    [Void]CreateStatL1DrawString() {
        [BattleEntityProperty]$AtkStat = $this.BERef.Stats[[StatId]::Attack]
        [BattleEntityProperty]$DefStat = $this.BERef.Stats[[StatId]::Defense]
        [ConsoleColor24]$AtkDrawColor  = [CCTextDefault24]::new()
        [ConsoleColor24]$DefDrawColor  = [CCTextDefault24]::new()
        [String]$AtkStatSignStr        = ''
        [String]$DefStatSignStr        = ''
        [String]$AtkStatFmtStr         = ''
        [String]$DefStatFmtStr         = ''

        If($AtkStat.AugmentTurnDuration -GT 0) {
            Switch($AtkStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $AtkDrawColor   = [BattleEntityProperty]::StatAugDrawColorPositive
                    $AtkStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $AtkDrawColor   = [BattleEntityProperty]::StatAugDrawColorNegative
                    $AtkStatSignStr = '-'
                }

                Default {
                    $AtkDrawColor   = [CCTextDefault24]::new()
                    $AtkStatSignStr = ' '
                }
            }
        } Else {
            $AtkDrawColor   = [CCTextDefault24]::new()
            $AtkStatSignStr = ' '
        }
        If($AtkStat.Base -LT 10) {
            $AtkStatFmtStr = "{0:d2}" -F $AtkStat.Base
        } Elseif($AtkStat.Base -GE 10) {
            $AtkStatFmtStr = "$($AtkStat.Base)"
        }

        If($DefStat.AugmentTurnDuration -GT 0) {
            Switch($DefStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $DefDrawColor   = [BattleEntityProperty]::StatAugDrawColorPositive
                    $DefStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $DefDrawColor   = [BattleEntityProperty]::StatAugDrawColorNegative
                    $DefStatSignStr = '-'
                }

                Default {
                    $DefDrawColor   = [CCTextDefault24]::new()
                    $DefStatSignStr = ' '
                }
            }
        } Else {
            $DefDrawColor   = [CCTextDefault24]::new()
            $DefStatSignStr = ' '
        }
        If($DefStat.Base -LT 10) {
            $DefStatFmtStr = "{0:d2}" -F $DefStat.Base
        } Elseif($DefStat.Base -GE 10) {
            $DefStatFmtStr = "$($DefStat.Base)"
        }

        $this.StatL1DrawString = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = $this.StatL1DrawCoordinates
                }
                UserData = 'ATK '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $AtkDrawColor
                }
                UserData = "$($AtkStatSignStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $AtkDrawColor
                }
                UserData = "$($AtkStatFmtStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' DEF '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $DefDrawColor
                }
                UserData = "$($DefStatSignStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $DefDrawColor
                }
                UserData   = "$($DefStatFmtStr)"
                UseATReset = $true
            }
        ))
    }

    [Void]CreateStatL2DrawString() {
        [BattleEntityProperty]$MatStat = $this.BERef.Stats[[StatId]::MagicAttack]
        [BattleEntityProperty]$MdfStat = $this.BERef.Stats[[StatId]::MagicDefense]
        [ConsoleColor24]$MatDrawColor  = [CCTextDefault24]::new()
        [ConsoleColor24]$MdfDrawColor  = [CCTextDefault24]::new()
        [String]$MatStatSignStr        = ''
        [String]$MdfStatSignStr        = ''
        [String]$MatStatFmtStr         = ''
        [String]$MdfStatFmtStr         = ''

        If($MatStat.AugmentTurnDuration -GT 0) {
            Switch($MatStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $MatDrawColor   = [BattleEntityProperty]::StatAugDrawColorPositive
                    $MatStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $MatDrawColor = [BattleEntityProperty]::StatAugDrawColorNegative
                    $MatStatSignStr = '-'
                }

                Default {
                    $MatDrawColor   = [CCTextDefault24]::new()
                    $MatStatSignStr = ' '
                }
            }
        } Else {
            $MatDrawColor   = [CCTextDefault24]::new()
            $MatStatSignStr = ' '
        }
        If($MatStat.Base -LT 10) {
            $MatStatFmtStr = "{0:d2}" -F $MatStat.Base
        } Elseif($MatStat.Base -GE 10) {
            $MatStatFmtStr = "$($MatStat.Base)"
        }

        If($MdfStat.AugmentTurnDuration -GT 0) {
            Switch($MdfStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $MdfDrawColor   = [BattleEntityProperty]::StatAugDrawColorPositive
                    $MdfStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $MdfDrawColor   = [BattleEntityProperty]::StatAugDrawColorNegative
                    $MdfStatSignStr = '-'
                }

                Default {
                    $MdfDrawColor   = [CCTextDefault24]::new()
                    $MdfStatSignStr = ' '
                }
            }
        } Else {
            $MdfDrawColor   = [CCTextDefault24]::new()
            $MdfStatSignStr = ' '
        }
        If($MdfStat.Base -LT 10) {
            $MdfStatFmtStr = "{0:d2}" -F $MdfStat.Base
        } Elseif($MdfStat.Base -GE 10) {
            $MdfStatFmtStr = "$($MdfStat.Base)"
        }

        $this.StatL2DrawString = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = $this.StatL2DrawCoordinates
                }
                UserData = 'MAT '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $MatDrawColor
                }
                UserData = "$($MatStatSignStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $MatDrawColor
                }
                UserData = "$($MatStatFmtStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' MDF '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $MdfDrawColor
                }
                UserData = "$($MdfStatSignStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $MdfDrawColor
                }
                UserData   = "$($MdfStatFmtStr)"
                UseATReset = $true
            }
        ))
    }

    [Void]CreateStatL3DrawString() {
        [BattleEntityProperty]$SpdStat = $this.BERef.Stats[[StatId]::Speed]
        [BattleEntityProperty]$AccStat = $this.BERef.Stats[[StatId]::Accuracy]
        [ConsoleColor24]$SpdDrawColor  = [CCTextDefault24]::new()
        [ConsoleColor24]$AccDrawColor  = [CCTextDefault24]::new()
        [String]$SpdStatSignStr        = ''
        [String]$AccStatSignStr        = ''
        [String]$SpdStatFmtStr         = ''
        [String]$AccStatFmtStr         = ''

        If($SpdStat.AugmentTurnDuration -GT 0) {
            Switch($SpdStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $SpdDrawColor   = [BattleEntityProperty]::StatAugDrawColorPositive
                    $SpdStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $SpdDrawColor = [BattleEntityProperty]::StatAugDrawColorNegative
                    $SpdStatSignStr = '-'
                }

                Default {
                    $SpdDrawColor   = [CCTextDefault24]::new()
                    $SpdStatSignStr = ' '
                }
            }
        } Else {
            $SpdDrawColor   = [CCTextDefault24]::new()
            $SpdStatSignStr = ' '
        }
        If($SpdStat.Base -LT 10) {
            $SpdStatFmtStr = "{0:d2}" -F $SpdStat.Base
        } Elseif($SpdStat.Base -GE 10) {
            $SpdStatFmtStr = "$($SpdStat.Base)"
        }

        If($AccStat.AugmentTurnDuration -GT 0) {
            Switch($AccStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $AccDrawColor   = [BattleEntityProperty]::StatAugDrawColorPositive
                    $AccStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $AccDrawColor   = [BattleEntityProperty]::StatAugDrawColorNegative
                    $AccStatSignStr = '-'
                }

                Default {
                    $AccDrawColor   = [CCTextDefault24]::new()
                    $AccStatSignStr = ' '
                }
            }
        } Else {
            $AccDrawColor   = [CCTextDefault24]::new()
            $AccStatSignStr = ' '
        }
        If($AccStat.Base -LT 10) {
            $AccStatFmtStr = "{0:d2}" -F $AccStat.Base
        } Elseif($AccStat.Base -GE 10) {
            $AccStatFmtStr = "$($AccStat.Base)"
        }

        $this.StatL3DrawString = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = $this.StatL3DrawCoordinates
                }
                UserData = 'SPD '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $SpdDrawColor
                }
                UserData = "$($SpdStatSignStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $SpdDrawColor
                }
                UserData = "$($SpdStatFmtStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' ACC '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $AccDrawColor
                }
                UserData = "$($AccStatSignStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $AccDrawColor
                }
                UserData   = "$($AccStatFmtStr)"
                UseATReset = $true
            }
        ))
    }

    [Void]CreateStatL4DrawString() {
        [BattleEntityProperty]$LckStat = $this.BERef.Stats[[StatId]::Luck]
        [ConsoleColor24]$LckDrawColor  = [CCTextDefault24]::new()
        [String]$LckStatSignStr        = ''
        [String]$LckStatFmtStr         = ''

        If($LckStat.AugmentTurnDuration -GT 0) {
            Switch($LckStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $LckDrawColor   = [BattleEntityProperty]::StatAugDrawColorPositive
                    $LckStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $LckDrawColor   = [BattleEntityProperty]::StatAugDrawColorNegative
                    $LckStatSignStr = '-'
                }

                Default {
                    $LckDrawColor   = [CCTextDefault24]::new()
                    $LckStatSignStr = ' '
                }
            }
        } Else {
            $LckDrawColor   = [CCTextDefault24]::new()
            $LckStatSignStr = ' '
        }
        If($LckStat.Base -LT 10) {
            $LckStatFmtStr = "{0:d2}" -F $LckStat.Base
        } Elseif($LckStat.Base -GE 10) {
            $LckStatFmtStr = "$($LckStat.Base)"
        }

        $this.StatL4DrawString = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = $this.StatL4DrawCoordinates
                }
                UserData = 'LCK '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $LckDrawColor
                }
                UserData = "$($LckStatSignStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $LckDrawColor
                }
                UserData   = "$($LckStatFmtStr)"
                UseATReset = $true
            }
        ))
    }

    [Void]SetAllFlagsDirty() {
        $this.HpDrawDirty     = $true
        $this.MpDrawDirty     = $true
        $this.StatL1DrawDirty = $true
        $this.StatL2DrawDirty = $true
        $this.StatL3DrawDirty = $true
        $this.StatL4DrawDirty = $true
    }
}
