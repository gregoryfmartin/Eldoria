using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# PS CONFIRM DIALOG
#
# A "DIALOG" THAT ALLOWS THE USER TO CONFIRM THEIR SELECTIONS FOR THE PLAYER
# SETUP INFORMATION.
#
###############################################################################

Class PSConfirmDialog : WindowBase {
    Static [Int]$WindowLTRow = 3
    Static [Int]$WindowLTColumn = 8
    Static [Int]$WindowRBRow = 21
    Static [Int]$WindowRBColumn = 54
    Static [Int]$LineName = 0
    Static [Int]$LineGender = 1
    Static [Int]$LineAffinity = 2
    Static [Int]$LineStatsHeader = 3
    Static [Int]$LineStatsAtk = 4
    Static [Int]$LineStatsDef = 5
    Static [Int]$LineStatsMat = 6
    Static [Int]$LineStatsMdf = 7
    Static [Int]$LineStatsSpd = 8
    Static [Int]$LineStatsAcc = 9
    Static [Int]$LineStatsLck = 10
    Static [Int]$LineActionPrompt = 11
    
    Static [String]$WindowTitle = 'Confirm Character'
    Static [String]$WindowLineBlankData = ' ' * ([PSConfirmDialog]::WindowRBColumn - [PSConfirmDialog]::WindowLtColumn)
    
    # THIS MAY NOT EVEN BE NEEDED GIVEN THAT NOTHING NEEDS REDRAWN IN THE WINDOW DYNAMICALLY?
    # Static [String]$LineBlankData = ' ' * 16
    
    [Boolean]$BgDirty
    [Boolean]$DataDirty
    
    [ATCoordinates]$ProfileImageDrawOffset
    
    [ATString]$BgActual
    
    [ATStringComposite[]]$LinesActual
    
    PSConfirmDialog() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row = [PSConfirmDialog]::WindowLTRow
            Column = [PSConfirmDialog]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row = [PSConfirmDialog]::WindowRBRow
            Column = [PSConfirmDialog]::WindowRBColumn
        }
        
        $this.UpdateDimensions()
        $this.SetupTitle([PSConfirmDialog]::WindowTitle, [CCTextDefault24]::new())
        
        $this.BgDirty = $true
        $this.DataDirty = $true
        $this.LinesActual = New-Object 'ATStringComposite[]' 12
        
        $this.ProfileImageDrawOffset = [ATCoordinates]@{
            Row = $this.LeftTop.Row + 2
            Column = $this.RightBottom.Column - 25
        }
        
        $this.BgActual = [ATString]@{
            Prefix = [ATStringPrefix]@{
                Coordinates = [ATCoordinates]@{
                    Row = $this.LeftTop.Row
                    Column = $this.LeftTop.Column
                }
            }
            UserData = "$([PSConfirmDialog]::WindowLineBlankData)"
            UseATReset = $true
        }
    }
    
    [Void]Draw() {
        If($this.BgDirty -EQ $true) {
            For([Int]$I = $this.LeftTop.Row; $I -LE $this.RightBottom.Row; $I++) {
                $this.BgActual.Prefix.Coordinates.Row = $I
                Write-Host "$($this.BgActual.ToAnsiControlSequenceString())"
            }
            $this.BgDirty = $false
        }
        
        ([WindowBase]$this).Draw()
        
        If($this.DataDirty -EQ $true) {
            $this.SetupNameActual()
            $this.SetupGenderActual()
            $this.SetupAffinityActual()
            $this.SetupStatsHeaderActual()
            $this.SetupStatsAtkActual()
            $this.SetupStatsDefActual()
            $this.SetupStatsMatActual()
            $this.SetupStatsMdfActual()
            $this.SetupStatsSpdActual()
            $this.SetupStatsAccActual()
            $this.SetupStatsLckActual()
            $this.SetupActionPromptActual()

            Foreach($Line in $this.LinesActual) {
                If($null -NE $Line) {
                    Write-Host "$($Line.ToAnsiControlSequenceString())"
                }
            }
            
            Switch($Script:ThePSGenderSelectionWindow.SelectedGender) {
                ([Gender]::Male) {
                    Write-Host "$($this.ProfileImageDrawOffset.ToAnsiControlSequenceString())$($Script:MaleImageData[$Script:ThePSProfileSelectWindow.ProfileImageProbe])"
                }
                
                ([Gender]::Female) {
                    Write-Host "$($this.ProfileImageDrawOffset.ToAnsiControlSequenceString())$($Script:FemaleImageData[$Script:ThePSProfileSelectWindow.ProfileImageProbe])"
                }
            }
            
            $this.DataDirty = $false
        }
    }
    
    [Void]HandleInput() {
        $KeyCap = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
        Switch($KeyCap.VirtualKeyCode) {
            13 { # ENTER
                # ASSIGN THE DATA TO THE PLAYER CONSTRUCT
                $Script:ThePlayer.Name = $Script:ThePSNameEntryWindow.NameActual.UserData
                $Script:ThePlayer.Gen = $Script:ThePSGenderSelectionWindow.SelectedGender
                $Script:ThePlayer.Stats[[StatId]::Attack].Base = ($Script:ThePSBonusPointAllocWindow.AtkPoints + $Script:ThePSBonusPointAllocWindow.AtkModPoints)
                $Script:ThePlayer.Stats[[StatId]::Defense].Base = ($Script:ThePSBonusPointAllocWindow.DefPoints + $Script:ThePSBonusPointAllocWindow.DefModPoints)
                $Script:ThePlayer.Stats[[StatId]::MagicAttack].Base = ($Script:ThePSBonusPointAllocWindow.MatPoints + $Script:ThePSBonusPointAllocWindow.MatModPoints)
                $Script:ThePlayer.Stats[[StatId]::MagicDefense].Base = ($Script:ThePSBonusPointAllocWindow.MdfPoints + $Script:ThePSBonusPointAllocWindow.MdfModPoints)
                $Script:ThePlayer.Stats[[StatId]::Speed].Base = ($Script:ThePSBonusPointAllocWindow.SpdPoints + $Script:ThePSBonusPointAllocWindow.SpdModPoints)
                $Script:ThePlayer.Stats[[StatId]::Luck].Base = ($Script:ThePSBonusPointAllocWindow.LckPoints + $Script:ThePSBonusPointAllocWindow.LckModPoints)
                $Script:ThePlayer.Stats[[StatId]::Accuracy].Base = ($Script:ThePSBonusPointAllocWindow.AccPoints + $Script:ThePSBonusPointAllocWindow.AccModPoints)
                $Script:ThePlayer.Affinity = "Elemental$($Script:ThePSAffinitySelectWindow.SelectedAffinity.CompositeActual[1].UserData.Trim())"
                
                # CHANGE THE STATE TO THE GAME PLAY STATE
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState = [GameStatePrimary]::GamePlayScreen
                
                Clear-Host
            
                Break
            }
            
            27 { # ESCAPE
                $Script:TheBufferManager.RestoreBufferBToActive()
                
                # REDRAW ALL THE WINDOWS
                $Script:ThePSNameEntryWindow.Draw()
                $Script:ThePSGenderSelectionWindow.Draw()
                $Script:ThePSBonusPointAllocWindow.SetAllDirty(); $Script:ThePSBonusPointAllocWindow.Draw()
                $Script:ThePSAffinitySelectWindow.SetAllDirty(); $Script:ThePSAffinitySelectWindow.Draw()
                $Script:ThePSProfileSelectWindow.SetAllDirty(); $Script:ThePSProfileSelectWindow.Draw()
                
                $Script:ThePssSubstate = [PlayerSetupScreenStates]::PlayerSetupProfileSelect
                
                Break
            }
            
            Default {
                Break
            }
        }
    }
    
    [Void]SetupNameActual() {
        $this.LinesActual[[PSConfirmDialog]::LineName] = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 2
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData = 'Name: '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVOrangeLight24]::new()
                }
                UserData = "$($Script:ThePSNameEntryWindow.NameActual.UserData)"
                UseATReset = $true
            }
        ))
    }
    
    [Void]SetupGenderActual() {
        $this.LinesActual[[PSConfirmDialog]::LineGender] = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LinesActual[[PSConfirmDialog]::LineName].CompositeActual[0].Prefix.Coordinates.Row + 2
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData = 'Gender: '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVOrangeLight24]::new()
                }
                UserData = (Invoke-Command -ScriptBlock {
                    If($Script:ThePSGenderSelectionWindow.SelectedGender -EQ [Gender]::Male) {
                        Return 'M'
                    } Else {
                        Return 'F'
                    }
                })
                UseATReset = $true
            }
        ))
    }
    
    [Void]SetupAffinityActual() {
        $this.LinesActual[[PSConfirmDialog]::LineAffinity] = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LinesActual[[PSConfirmDialog]::LineGender].CompositeActual[0].Prefix.Coordinates.Row + 2
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData = 'Affinity: '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:ThePSAffinitySelectWindow.SelectedAffinity.CompositeActual[0].Prefix.ForegroundColor
                }
                UserData = "$($Script:ThePSAffinitySelectWindow.SelectedAffinity.CompositeActual[0].UserData)$($Script:ThePSAffinitySelectWindow.SelectedAffinity.CompositeActual[1].UserData)"
                UseATReset = $true
            }
        ))
    }
    
    [Void]SetupStatsHeaderActual() {
        $this.LinesActual[[PSConfirmDialog]::LineStatsHeader] = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LinesActual[[PSConfirmDialog]::LineAffinity].CompositeActual[0].Prefix.Coordinates.Row + 2
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData = 'Stats'
                UseATReset = $true
            }
        ))
    }
    
    [Void]SetupStatsAtkActual() {
        $this.LinesActual[[PSConfirmDialog]::LineStatsAtk] = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LinesActual[[PSConfirmDialog]::LineStatsHeader].CompositeActual[0].Prefix.Coordinates.Row + 2
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = 'ATK: '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVOrangeLight24]::new()
                }
                UserData = "{0:d2}" -F ($Script:ThePSBonusPointAllocWindow.AtkPoints + $Script:ThePSBonusPointAllocWindow.AtkModPoints)
                UseATReset = $true
            }
        ))
        
        If($Script:ThePSGenderSelectionWindow.SelectedGender -EQ [Gender]::Male) {
            $this.LinesActual[[PSConfirmDialog]::LineStatsAtk].CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVYellowLight24]::new()
                    }
                    UserData = " `u{2729}"
                    UseATReset = $true
                }
            )
        }
        
        If($Script:ThePSBonusPointAllocWindow.AtkModPoints -GT 0) {
            $this.LinesActual[[PSConfirmDialog]::LineStatsAtk].CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVMintLight24]::new()
                    }
                    UserData = ' ^'
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]SetupStatsDefActual() {
        $this.LinesActual[[PSConfirmDialog]::LineStatsDef] = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LinesActual[[PSConfirmDialog]::LineStatsAtk].CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = 'DEF: '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVOrangeLight24]::new()
                }
                UserData = "{0:d2}" -F ($Script:ThePSBonusPointAllocWindow.DefPoints + $Script:ThePSBonusPointAllocWindow.DefModPoints)
                UseATReset = $true
            }
        ))
        
        If($Script:ThePSGenderSelectionWindow.SelectedGender -EQ [Gender]::Male) {
            $this.LinesActual[[PSConfirmDialog]::LineStatsDef].CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVYellowLight24]::new()
                    }
                    UserData = " `u{2729}"
                    UseATReset = $true
                }
            )
        }
        
        If($Script:ThePSBonusPointAllocWindow.DefModPoints -GT 0) {
            $this.LinesActual[[PSConfirmDialog]::LineStatsDef].CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVMintLight24]::new()
                    }
                    UserData = ' ^'
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]SetupStatsMatActual() {
        $this.LinesActual[[PSConfirmDialog]::LineStatsMat] = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LinesActual[[PSConfirmDialog]::LineStatsDef].CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = 'MAT: '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVOrangeLight24]::new()
                }
                UserData = "{0:d2}" -F ($Script:ThePSBonusPointAllocWindow.MatPoints + $Script:ThePSBonusPointAllocWindow.MatModPoints)
                UseATReset = $true
            }
        ))
        
        If($Script:ThePSGenderSelectionWindow.SelectedGender -EQ [Gender]::Female) {
            $this.LinesActual[[PSConfirmDialog]::LineStatsMat].CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVYellowLight24]::new()
                    }
                    UserData = " `u{2729}"
                    UseATReset = $true
                }
            )
        }
        
        If($Script:ThePSBonusPointAllocWindow.MatModPoints -GT 0) {
            $this.LinesActual[[PSConfirmDialog]::LineStatsMat].CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVMintLight24]::new()
                    }
                    UserData = ' ^'
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]SetupStatsMdfActual() {
        $this.LinesActual[[PSConfirmDialog]::LineStatsMdf] = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LinesActual[[PSConfirmDialog]::LineStatsMat].CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = 'MDF: '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVOrangeLight24]::new()
                }
                UserData = "{0:d2}" -F ($Script:ThePSBonusPointAllocWindow.MdfPoints + $Script:ThePSBonusPointAllocWindow.MdfModPoints)
                UseATReset = $true
            }
        ))
        
        If($Script:ThePSGenderSelectionWindow.SelectedGender -EQ [Gender]::Female) {
            $this.LinesActual[[PSConfirmDialog]::LineStatsMdf].CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVYellowLight24]::new()
                    }
                    UserData = " `u{2729}"
                    UseATReset = $true
                }
            )
        }
        
        If($Script:ThePSBonusPointAllocWindow.MdfModPoints -GT 0) {
            $this.LinesActual[[PSConfirmDialog]::LineStatsMdf].CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVMintLight24]::new()
                    }
                    UserData = ' ^'
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]SetupStatsSpdActual() {
        $this.LinesActual[[PSConfirmDialog]::LineStatsSpd] = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LinesActual[[PSConfirmDialog]::LineStatsMdf].CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = 'SPD: '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVOrangeLight24]::new()
                }
                UserData = "{0:d2}" -F ($Script:ThePSBonusPointAllocWindow.SpdPoints + $Script:ThePSBonusPointAllocWindow.SpdModPoints)
                UseATReset = $true
            }
        ))
        
        If($Script:ThePSGenderSelectionWindow.SelectedGender -EQ [Gender]::Female) {
            $this.LinesActual[[PSConfirmDialog]::LineStatsSpd].CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVYellowLight24]::new()
                    }
                    UserData = " `u{2729}"
                    UseATReset = $true
                }
            )
        }
        
        If($Script:ThePSBonusPointAllocWindow.SpdModPoints -GT 0) {
            $this.LinesActual[[PSConfirmDialog]::LineStatsSpd].CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVMintLight24]::new()
                    }
                    UserData = ' ^'
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]SetupStatsAccActual() {
        $this.LinesActual[[PSConfirmDialog]::LineStatsAcc] = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LinesActual[[PSConfirmDialog]::LineStatsSpd].CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = 'ACC: '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVOrangeLight24]::new()
                }
                UserData = "{0:d2}" -F ($Script:ThePSBonusPointAllocWindow.AccPoints + $Script:ThePSBonusPointAllocWindow.AccModPoints)
                UseATReset = $true
            }
        ))
        
        If($Script:ThePSBonusPointAllocWindow.AccModPoints -GT 0) {
            $this.LinesActual[[PSConfirmDialog]::LineStatsAcc].CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVMintLight24]::new()
                    }
                    UserData = ' ^'
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]SetupStatsLckActual() {
        $this.LinesActual[[PSConfirmDialog]::LineStatsLck] = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LinesActual[[PSConfirmDialog]::LineStatsAcc].CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = 'LCK: '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVOrangeLight24]::new()
                }
                UserData = "{0:d2}" -F ($Script:ThePSBonusPointAllocWindow.LckPoints + $Script:ThePSBonusPointAllocWindow.LckModPoints)
                UseATReset = $true
            }
        ))
        
        If($Script:ThePSBonusPointAllocWindow.LckModPoints -GT 0) {
            $this.LinesActual[[PSConfirmDialog]::LineStatsLck].CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVMintLight24]::new()
                    }
                    UserData = ' ^'
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]SetupActionPromptActual() {
        $this.LinesActual[[PSConfirmDialog]::LineActionPrompt] = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.RightBottom.Row - 1
                        Column = $this.RightBottom.Column - 23
                    }
                }
                UserData = 'Press '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVYellowLight24]::new()
                    Decorations = [ATDecoration]@{ Blink = $true }
                }
                UserData = 'Enter'
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' or '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVYellowLight24]::new()
                    Decorations = [ATDecoration]@{ Blink = $true }
                }
                UserData = 'Escape'
                UseATReset = $true
            }
        ))
    }
    
    [Void]SetAllDirty() {
        $this.BgDirty = $true
        $this.DataDirty = $true
        $this.BorderDrawDirty = [Boolean[]](
            $true,
            $true,
            $true,
            $true
        )
        $this.TitleDirty = $true
    }
}
