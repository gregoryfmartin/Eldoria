using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# STATUS HUD WINDOW
#
###############################################################################

Class StatusHudWindow : WindowBase {
    Static [Int]$WindowLTRow    = 1
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowRBRow    = 3
    Static [Int]$WindowRBColumn = 80

    Static [String]$LineBlankStr = '                                                                              '
    Static [String]$WindowTitle  = 'Status'

    [Boolean]$StatLineDrawDirty
    [ATString]$LineBlank
    [ATCoordinates]$StatLineDrawCoords
    [ATCoordinates]$StatSeparatorDrawCoords
    [ATStringComposite]$StatLineActual

    StatusHudWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [StatusHudWindow]::WindowLTRow
            Column = [StatusHudWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [StatusHudWindow]::WindowRBRow
            Column = [StatusHudWindow]::WindowRBColumn
        }

        $this.UpdateDimensions()

        $this.StatLineDrawDirty = $true
        $this.LineBlank = [ATString]@{
            UserData   = [StatusHudWindow]::LineBlankStr
            UseATReset = $true
        }
        $this.StatLineDrawCoords = [ATCoordinates]@{
            Row    = 2
            Column = 3
        }
        $this.StatSeparatorDrawCoords = [ATCoordinates]@{
            Row    = 2
            Column = [StatusHudWindow]::WindowRBColumn - 48
        }

        $this.SetupTitle([StatusHudWindow]::WindowTitle, [CCTextDefault24]::new())
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.StatLineDrawDirty -EQ $true) {
            $this.ComposeStatLineString()
            $this.LineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.StatLineDrawCoords)
            Write-Host "$($this.LineBlank.ToAnsiControlSequenceString())$($this.StatLineActual.ToAnsiControlSequenceString())"
            $this.StatLineDrawDirty = $false
        }

        # FOR SOME REASON, THE SETUP TITLE CAUSES THE LEFT BAR TO DISAPPEAR?
        # THIS IS REQUIRED TO DEAL WITH THAT.
        ([WindowBase]$this).Draw()
    }

    [Void]ComposeStatLineString() {
        [String]$AtkStatFmtStr = ''
        [String]$DefStatFmtStr = ''
        [String]$MatStatFmtStr = ''
        [String]$MdfStatFmtStr = ''
        [String]$SpdStatFmtStr = ''
        [String]$AccStatFmtStr = ''
        [String]$LckStatFmtStr = ''
        [String]$AtkDispStr    = 'ATK:'
        [String]$DefDispStr    = 'DEF:'
        [String]$MatDispStr    = 'MAT:'
        [String]$MdfDispStr    = 'MDF:'
        [String]$SpdDispStr    = 'SPD:'
        [String]$AccDispStr    = 'ACC:'
        [String]$LckDispStr    = 'LCK:'

        If($Script:ThePlayer.Stats[[StatId]::Attack].Base -LT 10) {
            $AtkStatFmtStr = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Attack].Base
        } Elseif($Script:ThePlayer.Stats[[StatId]::Attack].Base -GE 10) {
            $AtkStatFmtStr = "$($Script:ThePlayer.Stats[[StatId]::Attack].Base)"
        }
        If($Script:ThePlayer.Stats[[StatId]::Defense].Base -LT 10) {
            $DefStatFmtStr = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Defense].Base
        } Elseif($Script:ThePlayer.Stats[[StatId]::Defense].Base -GE 10) {
            $DefStatFmtStr = "$($Script:ThePlayer.Stats[[StatId]::Defense].Base)"
        }
        If($Script:ThePlayer.Stats[[StatId]::MagicAttack].Base -LT 10) {
            $MatStatFmtStr = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::MagicAttack].Base
        } Elseif($Script:ThePlayer.Stats[[StatId]::MagicAttack].Base -GE 10) {
            $MatStatFmtStr = "$($Script:ThePlayer.Stats[[StatId]::MagicAttack].Base)"
        }
        If($Script:ThePlayer.Stats[[StatId]::MagicDefense].Base -LT 10) {
            $MdfStatFmtStr = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::MagicDefense].Base
        } Elseif($Script:ThePlayer.Stats[[StatId]::MagicDefense].Base -GE 10) {
            $MdfStatFmtStr = "$($Script:ThePlayer.Stats[[StatId]::MagicDefense].Base)"
        }
        If($Script:ThePlayer.Stats[[StatId]::Speed].Base -LT 10) {
            $SpdStatFmtStr = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Speed].Base
        } Elseif($Script:ThePlayer.Stats[[StatId]::Speed].Base -GE 10) {
            $SpdStatFmtStr = "$($Script:ThePlayer.Stats[[StatId]::Speed].Base)"
        }
        If($Script:ThePlayer.Stats[[StatId]::Accuracy].Base -LT 10) {
            $AccStatFmtStr = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Accuracy].Base
        } Elseif($Script:ThePlayer.Stats[[StatId]::Accuracy].Base -GE 10) {
            $AccStatFmtStr = "$($Script:ThePlayer.Stats[[StatId]::Accuracy].Base)"
        }
        If($Script:ThePlayer.Stats[[StatId]::Luck].Base -LT 10) {
            $LckStatFmtStr = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Luck].Base
        } Elseif($Script:ThePlayer.Stats[[StatId]::Luck].Base -GE 10) {
            $LckStatFmtStr = "$($Script:ThePlayer.Stats[[StatId]::Luck].Base)"
        }

        $this.StatLineActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.Affinity].Item2
                    Coordinates     = [ATCoordinates]::new($this.StatLineDrawCoords)
                }
                UserData = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.Affinity].Item1) "
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($Script:ThePlayer.Name)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = [ATCoordinates]::new($this.StatSeparatorDrawCoords)
                }
                UserData = "$($AtkDispStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($AtkStatFmtStr) "
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($DefDispStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($DefStatFmtStr) "
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($MatDispStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($MatStatFmtStr) "
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($MdfDispStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($MdfStatFmtStr) "
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($SpdDispStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($SpdStatFmtStr) "
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($AccDispStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($AccStatFmtStr) "
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($LckDispStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = "$($LckStatFmtStr)"
                UseATReset = $true
            }
        ))
    }
}
