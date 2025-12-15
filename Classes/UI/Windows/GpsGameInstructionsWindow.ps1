using namespace System

Set-StrictMode -Version Latest


###############################################################################
#
# GPS GAME INSTRUCTIONS WINDOW
#
# A WINDOW THAT PROVIDES INSTRUCTIONS ON COMMANDS 
#
###############################################################################

Class GpsGameInstructionsWindow : WindowBase {
    Static [Int]$WindowLTRow             = 16
    Static [Int]$WindowLTColumn          = 1
    Static [Int]$WindowRBRow             = 23
    Static [Int]$WindowRBColumn          = 30
    Static [Int]$LCLabelColumnOffset     = 2
    Static [Int]$LCLabelWordColumnOffset = 4
    Static [Int]$RCLabelColumnOffset     = -10
    Static [Int]$RCLabelWordColumnOffset = -8
    
    Static [String]$WindowTitle = 'Instructions'
    
    [UIELabel[]]$Instructions
    
    GpsGameInstructionsWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [GpsGameInstructionsWindow]::WindowLTRow
            Column = [GpsGameInstructionsWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [GpsGameInstructionsWindow]::WindowRBRow
            Column = [GpsGameInstructionsWindow]::WindowRBColumn
        }
        
        $this.UpdateDimensions()
        $this.SetupTitle(
            [GpsGameInstructionsWindow]::WindowTitle,
            [CCTextDefault24]::new()
        )
        
        $this.SetupInstructions()
    }
    
    [Void]SetupInstructions() {
        $this.Instructions = @(
            [UIELabel]@{ # THE LEFT ARROW
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 1
                        Column = $this.LeftTop.Column + [GpsGameInstructionsWindow]::LCLabelColumnOffset
                    }
                }
                UseATReset = $true
                Dirty      = $true
            },
            [UIELabel]@{ # THE WORD LEFT
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 1
                        Column = $this.LeftTop.Column + [GpsGameInstructionsWindow]::LCLabelWordColumnOffset
                    }
                }
                UseATReset = $true
                Dirty      = $true
            },
            [UIELabel]@{ # THE UP ARROW
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 2
                        Column = $this.LeftTop.Column + [GpsGameInstructionsWindow]::LCLabelColumnOffset
                    }
                }
                UseATReset = $true
                Dirty      = $true
            },
            [UIELabel]@{ # THE WORD UP
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 2
                        Column = $this.LeftTop.Column + [GpsGameInstructionsWindow]::LCLabelWordColumnOffset
                    }
                }
                UseATReset = $true
                Dirty      = $true
            },
            [UIELabel]@{ # THE RIGHT ARROW
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 3
                        Column = $this.LeftTop.Column + [GpsGameInstructionsWindow]::LCLabelColumnOffset
                    }
                }
                UseATReset = $true
                Dirty      = $true
            },
            [UIELabel]@{ # THE WORD RIGHT
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 3
                        Column = $this.LeftTop.Column + [GpsGameInstructionsWindow]::LCLabelWordColumnOffset
                    }
                }
                UseATReset = $true
                Dirty      = $true
            },
            [UIELabel]@{ # THE DOWN ARROW
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 4
                        Column = $this.LeftTop.Column + [GpsGameInstructionsWindow]::LCLabelColumnOffset
                    }
                }
                UseATReset = $true
                Dirty      = $true
            },
            [UIELabel]@{ # THE WORD DOWN
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 4
                        Column = $this.LeftTop.Column + [GpsGameInstructionsWindow]::LCLabelWordColumnOffset
                    }
                }
                UseATReset = $true
                Dirty      = $true
            },
            [UIELabel]@{ # THE A CHARACTER
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 5
                        Column = $this.LeftTop.Column + [GpsGameInstructionsWindow]::LCLabelColumnOffset
                    }
                }
                UseATReset = $true
                Dirty      = $true
            },
            [UIELabel]@{ # THE MENU WORD
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 5
                        Column = $this.LeftTop.Column + [GpsGameInstructionsWindow]::LCLabelWordColumnOffset
                    }
                }
                UseATReset = $true
                Dirty      = $true
            },
            [UIELabel]@{ # THE S CHARACTER
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 6
                        Column = $this.LeftTop.Column + [GpsGameInstructionsWindow]::LCLabelColumnOffset
                    }
                }
                UseATReset = $true
                Dirty      = $true
            },
            [UIELabel]@{ # THE LOOK WORD
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 6
                        Column = $this.LeftTop.Column + [GpsGameInstructionsWindow]::LCLabelWordColumnOffset
                    }
                }
                UseATReset = $true
                Dirty      = $true
            },
            [UIELabel]@{ # THE D CHARACTER
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row  = $this.LeftTop.Row + 1
                        Column = $this.RightBottom.Column + [GpsGameInstructionsWindow]::RCLabelColumnOffset
                    }
                }
                UseATReset = $true
                Dirty = $true
            },
            [UIELabel]@{ # THE WORD EXAMINE
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 1
                        Column = $this.RightBottom.Column + [GpsGameInstructionsWindow]::RCLabelWordColumnOffset
                    }
                }
                UseATReset = $true
                Dirty = $true
            }
            [UIELabel]@{ # THE F CHARACTER
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 2
                        Column = $this.RightBottom.Column + [GpsGameInstructionsWindow]::RCLabelColumnOffset
                    }
                }
                UseATReset = $true
                Dirty = $true
            },
            [UIELabel]@{ # THE TAKE WORD
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 2
                        Column = $this.RightBottom.Column + [GpsGameInstructionsWindow]::RCLabelWordColumnOffset
                    }
                }
                UseATReset = $true
                Dirty = $true
            },
            [UIELabel]@{ # THE V CHARACTER
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 3
                        Column = $this.RightBottom.Column + [GpsGameInstructionsWindow]::RCLabelColumnOffset
                    }
                }
                UseATReset = $true
                Dirty = $true
            },
            [UIELabel]@{ # THE USE WORD
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 3
                        Column = $this.RightBottom.Column + [GpsGameInstructionsWindow]::RCLabelWordColumnOffset
                    }
                }
                UseATReset = $true
                Dirty = $true
            },
            [UIELabel]@{ # THE G CHARACTER
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 4
                        Column = $this.RightBottom.Column + [GpsGameInstructionsWindow]::RCLabelColumnOffset
                    }
                }
                UseATReset = $true
                Dirty = $true
            },
            [UIELabel]@{ # THE EN/EX WORD
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 4
                        Column = $this.RightBottom.Column + [GpsGameInstructionsWindow]::RCLabelWordColumnOffset
                    }
                }
                UseATReset = $true
                Dirty = $true
            }
        )
        
        $this.Instructions[0].SetUserData("`u{2190}")
        $this.Instructions[1].SetUserData('Left')
        $this.Instructions[2].SetUserData("`u{2191}")
        $this.Instructions[3].SetUserData('Up')
        $this.Instructions[4].SetUserData("`u{2192}")
        $this.Instructions[5].SetUserData('Right')
        $this.Instructions[6].SetUserData("`u{2193}")
        $this.Instructions[7].SetUserData('Down')
        $this.Instructions[8].SetUserData('A')
        $this.Instructions[9].SetUserData('Menu')
        $this.Instructions[10].SetUserData('S')
        $this.Instructions[11].SetUserData('Look')
        $this.Instructions[12].SetUserData('D')
        $this.Instructions[13].SetUserData('Examine')
        $this.Instructions[14].SetUserData('F')
        $this.Instructions[15].SetUserData('Take')
        $this.Instructions[16].SetUserData('V')
        $this.Instructions[17].SetUserData('Use')
        $this.Instructions[18].SetUserData('G')
        $this.Instructions[19].SetUserData('En/Ex')
    }
    
    [Void]Draw() {
        ([WindowBase]$this).Draw()
        
        Foreach($Label in $this.Instructions) {
            $Label.Draw()
        }
    }
}