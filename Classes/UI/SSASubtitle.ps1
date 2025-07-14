using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SSA SUBTITLE
#
###############################################################################

Class SSASubtitle {
    Static [Int]$DrawTop  = 9
    Static [Int]$DrawLeft = 33

    [Boolean]$Dirty
    [ATStringComposite]$Text

    SSASubtitle() {
        $this.Dirty = $true
        $this.Text  = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCRandom24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft
                    }
                }
                UserData   = 'A'
                UseATReset = $true
            },

            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 1
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 1
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },

            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 2
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCRandom24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 2
                    }
                }
                UserData   = 'N'
                UseATReset = $true
            },

            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 3
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCRandom24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 3
                    }
                }
                UserData   = 'O'
                UseATReset = $true
            },

            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 4
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCRandom24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 4
                    }
                }
                UserData   = 'T'
                UseATReset = $true
            },

            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 5
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 5
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },

            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 6
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCRandom24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 6
                    }
                }
                UserData   = 'G'
                UseATReset = $true
            },

            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 7
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCRandom24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 7
                    }
                }
                UserData   = 'A'
                UseATReset = $true
            },

            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 8
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCRandom24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 8
                    }
                }
                UserData   = 'R'
                UseATReset = $true
            },

            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 9
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCRandom24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 9
                    }
                }
                UserData   = 'Y'
                UseATReset = $true
            },

            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 10
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 10
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },

            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 11
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCRandom24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 11
                    }
                }
                UserData   = 'G'
                UseATReset = $true
            },

            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 12
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCRandom24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 12
                    }
                }
                UserData   = 'A'
                UseATReset = $true
            },

            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 13
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCRandom24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 13
                    }
                }
                UserData   = 'M'
                UseATReset = $true
            },

            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCBlack24]::new()
                    BackgroundColor = [CCBlack24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 14
                    }
                }
                UserData   = ' '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCRandom24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSASubtitle]::DrawTop
                        Column = [SSASubtitle]::DrawLeft + 14
                    }
                }
                UserData   = 'E'
                UseATReset = $true
            }
        ))
    }

    [Void]Draw() {
        $this.Text.CompositeActual[1].Prefix.ForegroundColor = [CCRandom24]::new()
        $this.Text.CompositeActual[5].Prefix.ForegroundColor = [CCRandom24]::new()
        $this.Text.CompositeActual[7].Prefix.ForegroundColor = [CCRandom24]::new()
        $this.Text.CompositeActual[9].Prefix.ForegroundColor = [CCRandom24]::new()
        $this.Text.CompositeActual[13].Prefix.ForegroundColor = [CCRandom24]::new()
        $this.Text.CompositeActual[15].Prefix.ForegroundColor = [CCRandom24]::new()
        $this.Text.CompositeActual[17].Prefix.ForegroundColor = [CCRandom24]::new()
        $this.Text.CompositeActual[19].Prefix.ForegroundColor = [CCRandom24]::new()
        $this.Text.CompositeActual[23].Prefix.ForegroundColor = [CCRandom24]::new()
        $this.Text.CompositeActual[25].Prefix.ForegroundColor = [CCRandom24]::new()
        $this.Text.CompositeActual[27].Prefix.ForegroundColor = [CCRandom24]::new()
        $this.Text.CompositeActual[29].Prefix.ForegroundColor = [CCRandom24]::new()

        If($this.Dirty -EQ $true) {
            Write-Host "$($this.Text.ToAnsiControlSequenceString())"
            $this.Dirty = $false
        }
    }
}
