using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SPLASH SCREEN A (SSA) "FIGLET"
#
# I'M HIJACKING THE FIGLET!
#
# ... SORT OF. IT'S HARD CODED. DOES THIS STILL COUNT?
#
###############################################################################

Class SSAFiglet {
    # I DID IT AGAIN! FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    Static [String]$LineBlankData = ' ' * $Script:MaxWidth

    # THIS LOOKS REALLY NEAT IN HERE
    # DOESN'T LINE UP FOR SHIT IN THE CODE, BUT WHATEVS
    Static [String]$TitleDataLine1 = '     ░        ░░  ░░░░░░░░       ░░░░      ░░░       ░░░        ░░░      ░░     '
    Static [String]$TitleDataLine2 = '     ▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒  ▒     '
    Static [String]$TitleDataLine3 = '     ▓      ▓▓▓▓  ▓▓▓▓▓▓▓▓  ▓▓▓▓  ▓▓  ▓▓▓▓  ▓▓       ▓▓▓▓▓▓  ▓▓▓▓▓  ▓▓▓▓  ▓     '
    Static [String]$TitleDataLine4 = '     █  ████████  ████████  ████  ██  ████  ██  ███  ██████  █████        █     '
    Static [String]$TitleDataLine5 = '     █        ██        ██       ████      ███  ████  ██        ██  ████  █     '

    Static [Int]$DrawTop  = 1
    Static [Int]$DrawLeft = 1

    [Boolean]$Dirty
    [ATStringComposite]$Title

    SSAFiglet() {
        $this.Dirty = $true
        $this.Title = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row    = [SSAFiglet]::DrawTop
                        Column = [SSAFiglet]::DrawLeft
                    }
                }
                UserData   = "$([SSAFiglet]::LineBlankData)"
                UseATReset = $true
            }
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleNMintLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSAFiglet]::DrawTop
                        Column = [SSAFiglet]::DrawLeft
                    }
                }
                UserData   = "$([SSAFiglet]::TitleDataLine1)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row    = [SSAFiglet]::DrawTop + 1
                        Column = [SSAFiglet]::DrawLeft
                    }
                }
                UserData   = "$([SSAFiglet]::LineBlankData)"
                UseATReset = $true
            }
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleNGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSAFiglet]::DrawTop + 1
                        Column = [SSAFiglet]::DrawLeft
                    }
                }
                UserData   = "$([SSAFiglet]::TitleDataLine2)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row    = [SSAFiglet]::DrawTop + 2
                        Column = [SSAFiglet]::DrawLeft
                    }
                }
                UserData   = "$([SSAFiglet]::LineBlankData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleNMintLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSAFiglet]::DrawTop + 2
                        Column = [SSAFiglet]::DrawLeft
                    }
                }
                UserData   = "$([SSAFiglet]::TitleDataLine3)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row    = [SSAFiglet]::DrawTop + 3
                        Column = [SSAFiglet]::DrawLeft
                    }
                }
                UserData   = "$([SSAFiglet]::LineBlankData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleNGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSAFiglet]::DrawTop + 3
                        Column = [SSAFiglet]::DrawLeft
                    }
                }
                UserData   = "$([SSAFiglet]::TitleDataLine4)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row    = [SSAFiglet]::DrawTop + 4
                        Column = [SSAFiglet]::DrawLeft
                    }
                }
                UserData   = "$([SSAFiglet]::LineBlankData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleNMintLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSAFiglet]::DrawTop + 4
                        Column = [SSAFiglet]::DrawLeft
                    }
                }
                UserData   = "$([SSAFiglet]::TitleDataLine5)"
                UseATReset = $true
            }
        ))
    }

    [Void]Draw() {
        If($this.Dirty -EQ $true) {
            Write-Host "$($this.Title.CompositeActual[0].ToAnsiControlSequenceString())$($this.Title.CompositeActual[1].ToAnsiControlSequenceString())"
            Start-Sleep -Seconds 0.75
            Write-Host "$($this.Title.CompositeActual[2].ToAnsiControlSequenceString())$($this.Title.CompositeActual[3].ToAnsiControlSequenceString())"
            Start-Sleep -Seconds 0.75
            Write-Host "$($this.Title.CompositeActual[4].ToAnsiControlSequenceString())$($this.Title.CompositeActual[5].ToAnsiControlSequenceString())"
            Start-Sleep -Seconds 0.75
            Write-Host "$($this.Title.CompositeActual[6].ToAnsiControlSequenceString())$($this.Title.CompositeActual[7].ToAnsiControlSequenceString())"
            Start-Sleep -Seconds 0.75
            Write-Host "$($this.Title.CompositeActual[8].ToAnsiControlSequenceString())$($this.Title.CompositeActual[9].ToAnsiControlSequenceString())"
            Start-Sleep -Seconds 0.75
            $this.Dirty = $false
        }
    }
}
