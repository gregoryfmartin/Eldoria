using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# PS BONUS POINT ALLOC WINDOW
#
# ALLOWS THE PLAYER TO ALLOCATE BONUS POINTS TO THE RANDOMLY GENERATED STATS.
# THESE STATS CAN BE REROLLED BY PRESSING THE R KEY.
#
###############################################################################

Class PSBonusPointAllocWindow : WindowBase {
    Static [Int]$WindowLTRow = 5
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowRBRow = 15
    Static [Int]$WindowRBColumn = 22
    
    Static [String]$WindowTitle = 'Bonus Points'
    Static [String]$PointsLeftData = 'Points Left: '
    Static [String]$AtkPromptData = 'ATK: '
    Static [String]$DefPromptData = 'DEF: '
    Static [String]$MatPromptData = 'MAT: '
    Static [String]$MdfPromptData = 'MDF: '
    Static [String]$SpdPromptData = 'SPD: '
    Static [String]$AccPromptData = 'ACC: '
    Static [String]$LckPromptData = 'LCK: '
    Static [String]$ChevronLeftData = "`u{27E8}"
    Static [String]$ChevronRightData = "`u{27E9}"
    Static [String]$NumberDialLeftArrowData = "`u{23F4}"
    Static [String]$NumberDialRightArrowData = "`u{23F5}"
    
    Static [ConsoleColor24]$NumberDialActiveColor = [CCAppleNPinkLight24]::new()
    
    [Int]$PointsPool
    [Int]$AtkPoints
    [Int]$DefPoints
    [Int]$MatPoints
    [Int]$MdfPoints
    [Int]$SpdPoints
    [Int]$AccPoints
    [Int]$LckPoints
    [Int]$AtkModPoints
    [Int]$DefModPoints
    [Int]$MatModPoints
    [Int]$MdfModPoints
    [Int]$SpdModPoints
    [Int]$AccModPoints
    [Int]$LckModPoints
    
    [Boolean]$PointsLeftPromptDirty
    [Boolean]$AtkPromptDirty
    [Boolean]$DefPromptDirty
    [Boolean]$MatPromptDirty
    [Boolean]$MdfPromptDirty
    [Boolean]$SpdPromptDirty
    [Boolean]$AccPromptDirty
    [Boolean]$LckPromptDirty
    [Boolean]$PointsLeftDataDirty
    [Boolean]$AtkDataDirty
    [Boolean]$DefDataDirty
    [Boolean]$MatDataDirty
    [Boolean]$MdfDataDirty
    [Boolean]$SpdDataDirty
    [Boolean]$AccDataDirty
    [Boolean]$LckDataDirty
    
    [ATStringComposite]$PointsLeftActual
    [ATStringComposite]$AtkPromptActual
    [ATStringComposite]$DefPromptActual
    [ATStringComposite]$MatPromptActual
    [ATStringComposite]$MdfPromptActual
    [ATStringComposite]$SpdPromptActual
    [ATStringComposite]$AccPromptActual
    [ATStringComposite]$LckPromptActual
    
    [PSBonusPointAllocState]$State

    PSBonusPointAllocWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [PSBonusPointAllocWindow]::WindowLTRow
            Column = [PSBonusPointAllocWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [PSBonusPointAllocWindow]::WindowRBRow
            Column = [PSBonusPointAllocWindow]::WindowRBColumn
        }
        
        $this.UpdateDimensions()
        $this.SetupTitle([PSBonusPointAllocWindow]::WindowTitle, [CCTextDefault24]::new())
        
        $this.PointsLeftPromptDirty = $true
        $this.AtkPromptDirty = $true
        $this.DefPromptDirty = $true
        $this.MatPromptDirty = $true
        $this.MdfPromptDirty = $true
        $this.SpdPromptDirty = $true
        $this.AccPromptDirty = $true
        $this.LckPromptDirty = $true
        $this.PointsLeftDataDirty = $false
        $this.AtkDataDirty = $false
        $this.DefDataDirty = $false
        $this.MatDataDirty = $false
        $this.MdfDataDirty = $false
        $this.SpdDataDirty = $false
        $this.AccDataDirty = $false
        $this.LckDataDirty = $false
        $this.State = [PSBonusPointAllocState]::AtkPointsMod
        $this.PointsPool = 10
        $this.AtkPoints = 0
        $this.DefPoints = 0
        $this.MatPoints = 0
        $this.MdfPoints = 0
        $this.SpdPoints = 0
        $this.AccPoints = 0
        $this.LckPoints = 0
        $this.AtkModPoints = 0
        $this.DefModPoints = 0
        $this.MatModPoints = 0
        $this.MdfModPoints = 0
        $this.SpdModPoints = 0
        $this.AccModPoints = 0
        $this.LckModPoints = 0
        
        $this.GenerateStats()
        
        $this.SetupPointsLeftActual()
        $this.SetupAtkPromptActual()
        $this.SetupDefPromptActual()
        $this.SetupMatPromptActual()
        $this.SetupMdfPromptActual()
        $this.SetupSpdPromptActual()
        $this.SetupAccPromptActual()
        $this.SetupLckPromptActual()
        
        $this.UpdateStateTargetVisuals()
    }
    
    [Void]GenerateStats() {
        $this.AtkPoints = (Get-Random -Minimum 3 -Maximum 15)
        $this.DefPoints = (Get-Random -Minimum 3 -Maximum 15)
        $this.MatPoints = (Get-Random -Minimum 3 -Maximum 15)
        $this.MdfPoints = (Get-Random -Minimum 3 -Maximum 15)
        $this.SpdPoints = (Get-Random -Minimum 3 -Maximum 15)
        $this.AccPoints = (Get-Random -Minimum 3 -Maximum 15)
        $this.LckPoints = (Get-Random -Minimum 3 -Maximum 15)
        
        Switch($Script:ThePSGenderSelectionWindow.SelectedGender) {
            ([Gender]::Male) {
                $this.AtkPoints += 3
                $this.DefPoints += 2
                
                Break
            }
            
            ([Gender]::Female) {
                $this.MatPoints += 2
                $this.MdfPoints += 1
                $this.SpdPoints += 2
                
                Break
            }
        }
    }
    
    [Void]CycleStateForward() {
        Switch($this.State) {
            ([PSBonusPointAllocState]::AtkPointsMod) {
                $this.State = [PSBonusPointAllocState]::DefPointsMod
                
                $this.AtkPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecorationNone]::new()
                $this.AtkPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCTextDefault24]::new()
                $this.AtkPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecorationNone]::new()
                $this.AtkPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::DefPointsMod) {
                $this.State = [PSBonusPointAllocState]::MatPointsMod
                
                $this.DefPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecorationNone]::new()
                $this.DefPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCTextDefault24]::new()
                $this.DefPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecorationNone]::new()
                $this.DefPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::MatPointsMod) {
                $this.State = [PSBonusPointAllocState]::MdfPointsMod
                
                $this.MatPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecorationNone]::new()
                $this.MatPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCTextDefault24]::new()
                $this.MatPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecorationNone]::new()
                $this.MatPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::MdfPointsMod) {
                $this.State = [PSBonusPointAllocState]::SpdPointsMod
                
                $this.MdfPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecorationNone]::new()
                $this.MdfPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCTextDefault24]::new()
                $this.MdfPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecorationNone]::new()
                $this.MdfPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::SpdPointsMod) {
                $this.State = [PSBonusPointAllocState]::AccPointsMod
                
                $this.SpdPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecorationNone]::new()
                $this.SpdPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCTextDefault24]::new()
                $this.SpdPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecorationNone]::new()
                $this.SpdPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::AccPointsMod) {
                $this.State = [PSBonusPointAllocState]::LckPointsMod
                
                $this.AccPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecorationNone]::new()
                $this.AccPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCTextDefault24]::new()
                $this.AccPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecorationNone]::new()
                $this.AccPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::LckPointsMod) {
                $this.State = [PSBonusPointAllocState]::AtkPointsMod
                
                $this.LckPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecorationNone]::new()
                $this.LckPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCTextDefault24]::new()
                $this.LckPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecorationNone]::new()
                $this.LckPromptDirty = $true
                
                Break
            }
        }
        
        $this.UpdateStateTargetVisuals()
    }
    
    [Void]CycleStateBackward() {
        Switch($this.State) {
            ([PSBonusPointAllocState]::AtkPointsMod) {
                $this.State = [PSBonusPointAllocState]::LckPointsMod
                
                $this.AtkPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecorationNone]::new()
                $this.AtkPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCTextDefault24]::new()
                $this.AtkPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecorationNone]::new()
                $this.AtkPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::LckPointsMod) {
                $this.State = [PSBonusPointAllocState]::AccPointsMod
                
                $this.LckPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecorationNone]::new()
                $this.LckPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCTextDefault24]::new()
                $this.LckPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecorationNone]::new()
                $this.LckPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::AccPointsMod) {
                $this.State = [PSBonusPointAllocState]::SpdPointsMod
                
                $this.AccPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecorationNone]::new()
                $this.AccPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCTextDefault24]::new()
                $this.AccPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecorationNone]::new()
                $this.AccPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::SpdPointsMod) {
                $this.State = [PSBonusPointAllocState]::MdfPointsMod
                
                $this.SpdPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecorationNone]::new()
                $this.SpdPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCTextDefault24]::new()
                $this.SpdPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecorationNone]::new()
                $this.SpdPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::MdfPointsMod) {
                $this.State = [PSBonusPointAllocState]::MatPointsMod
                
                $this.MdfPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecorationNone]::new()
                $this.MdfPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCTextDefault24]::new()
                $this.MdfPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecorationNone]::new()
                $this.MdfPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::MatPointsMod) {
                $this.State = [PSBonusPointAllocState]::DefPointsMod
                
                $this.MatPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecorationNone]::new()
                $this.MatPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCTextDefault24]::new()
                $this.MatPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecorationNone]::new()
                $this.MatPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::DefPointsMod) {
                $this.State = [PSBonusPointAllocState]::AtkPointsMod
                
                $this.DefPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecorationNone]::new()
                $this.DefPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCTextDefault24]::new()
                $this.DefPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecorationNone]::new()
                $this.DefPromptDirty = $true
                
                Break
            }
        }
        
        $this.UpdateStateTargetVisuals()
    }
    
    [Void]UpdateStateTargetVisuals() {
        Switch($this.State) {
            ([PSBonusPointAllocState]::AtkPointsMod) {
                $this.AtkPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
                $this.AtkPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCAppleNYellowLight24]::new()
                $this.AtkPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
                $this.AtkPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::DefPointsMod) {
                $this.DefPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
                $this.DefPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCAppleNYellowLight24]::new()
                $this.DefPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
                $this.DefPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::MatPointsMod) {
                $this.MatPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
                $this.MatPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCAppleNYellowLight24]::new()
                $this.MatPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
                $this.MatPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::MdfPointsMod) {
                $this.MdfPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
                $this.MdfPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCAppleNYellowLight24]::new()
                $this.MdfPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
                $this.MdfPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::SpdPointsMod) {
                $this.SpdPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
                $this.SpdPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCAppleNYellowLight24]::new()
                $this.SpdPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
                $this.SpdPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::AccPointsMod) {
                $this.AccPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
                $this.AccPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCAppleNYellowLight24]::new()
                $this.AccPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
                $this.AccPromptDirty = $true
                
                Break
            }
            
            ([PSBonusPointAllocState]::LckPointsMod) {
                $this.LckPromptActual.CompositeActual[0].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
                $this.LckPromptActual.CompositeActual[0].Prefix.ForegroundColor = [CCAppleNYellowLight24]::new()
                $this.LckPromptActual.CompositeActual[2].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
                $this.LckPromptDirty = $true
                
                Break
            }
        }
    }
    
    [Void]IncrementStatModVal() {
        Switch($this.State) {
            ([PSBonusPointAllocState]::AtkPointsMod) {
                If($this.PointsPool -GT 0) {
                    $this.AtkModPoints++
                    $this.DecrementPointsLeft()
                    $this.UpdateAtkPromptActual()
                }
                
                Break
            }
            
            ([PSBonusPointAllocState]::DefPointsMod) {
                If($this.PointsPool -GT 0) {
                    $this.DefModPoints++
                    $this.DecrementPointsLeft()
                    $this.UpdateDefPromptActual()
                }
                
                Break
            }
            
            ([PSBonusPointAllocState]::MatPointsMod) {
                If($this.PointsPool -GT 0) {
                    $this.MatModPoints++
                    $this.DecrementPointsLeft()
                    $this.UpdateMatPromptActual()
                }
                
                Break
            }
            
            ([PSBonusPointAllocState]::MdfPointsMod) {
                If($this.PointsPool -GT 0) {
                    $this.MdfModPoints++
                    $this.DecrementPointsLeft()
                    $this.UpdateMdfPromptActual()
                }
                
                Break
            }
            
            ([PSBonusPointAllocState]::SpdPointsMod) {
                If($this.PointsPool -GT 0) {
                    $this.SpdModPoints++
                    $this.DecrementPointsLeft()
                    $this.UpdateSpdPromptActual()
                }
                
                Break
            }
            
            ([PSBonusPointAllocState]::AccPointsMod) {
                If($this.PointsPool -GT 0) {
                    $this.AccModPoints++
                    $this.DecrementPointsLeft()
                    $this.UpdateAccPromptActual()
                }
                
                Break
            }
            
            ([PSBonusPointAllocState]::LckPointsMod) {
                If($this.PointsPool -GT 0) {
                    $this.LckModPoints++
                    $this.DecrementPointsLeft()
                    $this.UpdateLckPromptActual()
                }
                
                Break
            }
        }
    }
    
    [Void]DecrementStatModVal() {
        Switch($this.State) {
            ([PSBonusPointAllocState]::AtkPointsMod) {
                If($this.PointsPool -LT 10 -AND $this.AtkModPoints -GT 0) {
                    $this.AtkModPoints--
                    $this.IncrementPointsLeft()
                    $this.UpdateAtkPromptActual()
                }
                
                Break
            }
            
            ([PSBonusPointAllocState]::DefPointsMod) {
                If($this.PointsPool -LT 10 -AND $this.DefModPoints -GT 0) {
                    $this.DefModPoints--
                    $this.IncrementPointsLeft()
                    $this.UpdateDefPromptActual()
                }
                
                Break
            }
            
            ([PSBonusPointAllocState]::MatPointsMod) {
                If($this.PointsPool -LT 10 -AND $this.MatModPoints -GT 0) {
                    $this.MatModPoints--
                    $this.IncrementPointsLeft()
                    $this.UpdateMatPromptActual()
                }
                
                Break
            }
            
            ([PSBonusPointAllocState]::MdfPointsMod) {
                If($this.PointsPool -LT 10 -AND $this.MdfModPoints -GT 0) {
                    $this.MdfModPoints--
                    $this.IncrementPointsLeft()
                    $this.UpdateMdfPromptActual()
                }
                
                Break
            }
            
            ([PSBonusPointAllocState]::SpdPointsMod) {
                If($this.PointsPool -LT 10 -AND $this.SpdModPoints -GT 0) {
                    $this.SpdModPoints--
                    $this.IncrementPointsLeft()
                    $this.UpdateSpdPromptActual()
                }
                
                Break
            }
            
            ([PSBonusPointAllocState]::AccPointsMod) {
                If($this.PointsPool -LT 10 -AND $this.AccModPoints -GT 0) {
                    $this.AccModPoints--
                    $this.IncrementPointsLeft()
                    $this.UpdateAccPromptActual()
                }
                
                Break
            }
            
            ([PSBonusPointAllocState]::LckPointsMod) {
                If($this.PointsPool -LT 10 -AND $this.LckModPoints -GT 0) {
                    $this.LckModPoints--
                    $this.IncrementPointsLeft()
                    $this.UpdateLckPromptActual()
                }
                
                Break
            }
        }
    }
    
    [Void]SetupPointsLeftActual() {
        $this.PointsLeftActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 1
                        Column = $this.LeftTop.Column + 3
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::PointsLeftData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 1
                        Column = ($this.LeftTop.Column + 3) + [PSBonusPointAllocWindow]::PointsLeftData.Length
                    }
                }
                UserData = "{0:d2}" -F $this.PointsPool
                UseATReset = $true
            }
        ))
    }
    
    [Void]UpdatePointsLeftActual() {
        If($this.PointsPool -LE 0) {
            $this.PointsLeftActual.CompositeActual[1].Prefix.ForegroundColor = [CCAppleNRedLight24]::new()
            $this.PointsLeftActual.CompositeActual[1].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
        } Else {
            $this.PointsLeftActual.CompositeActual[1].Prefix.ForegroundColor = [CCTextDefault24]::new()
            $this.PointsLeftActual.CompositeActual[1].Prefix.Decorations = [ATDecorationNone]::new()
        }
        
        $this.PointsLeftActual.CompositeActual[1].UserData = "{0:d2}" -F $this.PointsPool
        $this.PointsLeftDataDirty = $true
    }
    
    [Void]DecrementPointsLeft() {
        If(($this.PointsPool - 1) -GE 0) {
            $this.PointsPool--
            
            $this.UpdatePointsLeftActual()
        }
    }
    
    [Void]IncrementPointsLeft() {
        If(($this.PointsPool + 1) -LE 10) {
            $this.PointsPool++
            
            $this.UpdatePointsLeftActual()
        }
    }
    
    [Void]SetupAtkPromptActual() {
        $this.AtkPromptActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 3
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::AtkPromptData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 3
                        Column = ($this.LeftTop.Column + 4) + [PSBonusPointAllocWindow]::AtkPromptData.Length + 1
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::NumberDialLeftArrowData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 3
                        Column = ($this.LeftTop.Column + 4) + [PSBonusPointAllocWindow]::AtkPromptData.Length + 2
                    }
                }
                UserData = " {0:d3} " -F ($this.AtkPoints + $this.AtkModPoints)
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 3
                        Column = ($this.LeftTop.Column + 4) + [PSBonusPointAllocWindow]::AtkPromptData.Length + 7
                    }
                }
                UserData   = "$([PSBonusPointAllocWindow]::NumberDialRightArrowData)"
                UseATReset = $true
            }
        ))
        
        If($Script:ThePSGenderSelectionWindow.SelectedGender -EQ [Gender]::Male) {
            $this.AtkPromptActual.CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVYellowLight24]::new()
                    }
                    UserData   = " `u{2729}"
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]UpdateAtkPromptActual() {
        $this.AtkPromptActual.CompositeActual[2].UserData = " {0:d3} " -F ($this.AtkPoints + $this.AtkModPoints)
        
        If($this.AtkModPoints -EQ 0) {
            $this.AtkPromptActual.CompositeActual[2].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Elseif($this.AtkModPoints -GT 0) {
            $this.AtkPromptActual.CompositeActual[2].Prefix.ForegroundColor = [CCAppleNMintLight24]::new()
        }
        
        $this.AtkDataDirty = $true
    }
    
    [Void]SetupDefPromptActual() {
        $this.DefPromptActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.AtkPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.AtkPromptActual.CompositeActual[0].Prefix.Coordinates.Column
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::DefPromptData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.AtkPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.AtkPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::DefPromptData.Length + 1
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::NumberDialLeftArrowData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.AtkPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.AtkPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::DefPromptData.Length + 2
                    }
                }
                UserData = " {0:d3} " -F ($this.DefPoints + $this.DefModPoints)
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.AtkPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.AtkPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::DefPromptData.Length + 7
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::NumberDialRightArrowData)"
                UseATReset = $true
            }
        ))
        
        If($Script:ThePSGenderSelectionWindow.SelectedGender -EQ [Gender]::Male) {
            $this.DefPromptActual.CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVYellowLight24]::new()
                    }
                    UserData   = " `u{2729}"
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]UpdateDefPromptActual() {
        $this.DefPromptActual.CompositeActual[2].UserData = " {0:d3} " -F ($this.DefPoints + $this.DefModPoints)
        
        If($this.DefModPoints -EQ 0) {
            $this.DefPromptActual.CompositeActual[2].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Elseif($this.DefModPoints -GT 0) {
            $this.DefPromptActual.CompositeActual[2].Prefix.ForegroundColor = [CCAppleNMintLight24]::new()
        }
        
        $this.DefDataDirty = $true
    }
    
    [Void]SetupMatPromptActual() {
        $this.MatPromptActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.DefPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.DefPromptActual.CompositeActual[0].Prefix.Coordinates.Column
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::MatPromptData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.DefPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.DefPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::MatPromptData.Length + 1
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::NumberDialLeftArrowData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.DefPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.DefPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::MatPromptData.Length + 2
                    }
                }
                UserData = " {0:d3} " -F ($this.MatPoints + $this.MatModPoints)
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.DefPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.DefPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::MatPromptData.Length + 7
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::NumberDialRightArrowData)"
                UseATReset = $true
            }
        ))
        
        If($Script:ThePSGenderSelectionWindow.SelectedGender -EQ [Gender]::Female) {
            $this.MatPromptActual.CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVYellowLight24]::new()
                    }
                    UserData   = " `u{2729}"
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]UpdateMatPromptActual() {
        $this.MatPromptActual.CompositeActual[2].UserData = " {0:d3} " -F ($this.MatPoints + $this.MatModPoints)
        
        If($this.MatModPoints -EQ 0) {
            $this.MatPromptActual.CompositeActual[2].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Elseif($this.MatModPoints -GT 0) {
            $this.MatPromptActual.CompositeActual[2].Prefix.ForegroundColor = [CCAppleNMintLight24]::new()
        }
        
        $this.MatDataDirty = $true
    }
    
    [Void]SetupMdfPromptActual() {
        $this.MdfPromptActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.MatPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.MatPromptActual.CompositeActual[0].Prefix.Coordinates.Column
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::MdfPromptData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.MatPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.MatPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::MdfPromptData.Length + 1
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::NumberDialLeftArrowData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.MatPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.MatPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::MdfPromptData.Length + 2
                    }
                }
                UserData = " {0:d3} " -F ($this.MdfPoints + $this.MdfModPoints)
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.MatPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.MatPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::MdfPromptData.Length + 7
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::NumberDialRightArrowData)"
                UseATReset = $true
            }
        ))
        
        If($Script:ThePSGenderSelectionWindow.SelectedGender -EQ [Gender]::Female) {
            $this.MdfPromptActual.CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVYellowLight24]::new()
                    }
                    UserData   = " `u{2729}"
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]UpdateMdfPromptActual() {
        $this.MdfPromptActual.CompositeActual[2].UserData = " {0:d3} " -F ($this.MdfPoints + $this.MdfModPoints)
        
        If($this.MdfModPoints -EQ 0) {
            $this.MdfPromptActual.CompositeActual[2].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Elseif($this.MdfModPoints -GT 0) {
            $this.MdfPromptActual.CompositeActual[2].Prefix.ForegroundColor = [CCAppleNMintLight24]::new()
        }
        
        $this.MdfDataDirty = $true
    }
    
    [Void]SetupSpdPromptActual() {
        $this.SpdPromptActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.MdfPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.MdfPromptActual.CompositeActual[0].Prefix.Coordinates.Column
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::SpdPromptData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.MdfPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.MdfPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::SpdPromptData.Length + 1
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::NumberDialLeftArrowData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.MdfPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.MdfPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::SpdPromptData.Length + 2
                    }
                }
                UserData = " {0:d3} " -F ($this.SpdPoints + $this.SpdModPoints)
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.MdfPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.MdfPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::SpdPromptData.Length + 7
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::NumberDialRightArrowData)"
                UseATReset = $true
            }
        ))
        
        If($Script:ThePSGenderSelectionWindow.SelectedGender -EQ [Gender]::Female) {
            $this.SpdPromptActual.CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVYellowLight24]::new()
                    }
                    UserData   = " `u{2729}"
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]UpdateSpdPromptActual() {
        $this.SpdPromptActual.CompositeActual[2].UserData = " {0:d3} " -F ($this.SpdPoints + $this.SpdModPoints)
        
        If($this.SpdModPoints -EQ 0) {
            $this.SpdPromptActual.CompositeActual[2].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Elseif($this.SpdModPoints -GT 0) {
            $this.SpdPromptActual.CompositeActual[2].Prefix.ForegroundColor = [CCAppleNMintLight24]::new()
        }
        
        $this.SpdDataDirty = $true
    }
    
    [Void]SetupAccPromptActual() {
        $this.AccPromptActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.SpdPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.SpdPromptActual.CompositeActual[0].Prefix.Coordinates.Column
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::AccPromptData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.SpdPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.SpdPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::AccPromptData.Length + 1
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::NumberDialLeftArrowData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.SpdPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.SpdPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::AccPromptData.Length + 2
                    }
                }
                UserData = " {0:d3} " -F ($this.AccPoints + $this.AccModPoints)
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.SpdPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.SpdPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::AccPromptData.Length + 7
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::NumberDialRightArrowData)"
                UseATReset = $true
            }
        ))
    }
    
    [Void]UpdateAccPromptActual() {
        $this.AccPromptActual.CompositeActual[2].UserData = " {0:d3} " -F ($this.AccPoints + $this.AccModPoints)
        
        If($this.AccModPoints -EQ 0) {
            $this.AccPromptActual.CompositeActual[2].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Elseif($this.AccModPoints -GT 0) {
            $this.AccPromptActual.CompositeActual[2].Prefix.ForegroundColor = [CCAppleNMintLight24]::new()
        }
        
        $this.AccDataDirty = $true
    }
    
    [Void]SetupLckPromptActual() {
        $this.LckPromptActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.AccPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.AccPromptActual.CompositeActual[0].Prefix.Coordinates.Column
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::LckPromptData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.AccPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.AccPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::LckPromptData.Length + 1
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::NumberDialLeftArrowData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.AccPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.AccPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::LckPromptData.Length + 2
                    }
                }
                UserData = " {0:d3} " -F ($this.LckPoints + $this.LckModPoints)
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = $this.AccPromptActual.CompositeActual[0].Prefix.Coordinates.Row + 1
                        Column = $this.AccPromptActual.CompositeActual[0].Prefix.Coordinates.Column + [PSBonusPointAllocWindow]::LckPromptData.Length + 7
                    }
                }
                UserData = "$([PSBonusPointAllocWindow]::NumberDialRightArrowData)"
                UseATReset = $true
            }
        ))
    }
    
    [Void]UpdateLckPromptActual() {
        $this.LckPromptActual.CompositeActual[2].UserData = " {0:d3} " -F ($this.LckPoints + $this.LckModPoints)
        
        If($this.LckModPoints -EQ 0) {
            $this.LckPromptActual.CompositeActual[2].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Elseif($this.LckModPoints -GT 0) {
            $this.LckPromptActual.CompositeActual[2].Prefix.ForegroundColor = [CCAppleNMintLight24]::new()
        }
        
        $this.LckDataDirty = $true
    }
    
    [Void]Draw() {
        ([WindowBase]$this).Draw()
        
        If($this.PointsLeftPromptDirty -EQ $true) {
            Write-Host "$($this.PointsLeftActual.ToAnsiControlSequenceString())"
            $this.PointsLeftPromptDirty = $false
        }
        If($this.PointsLeftDataDirty -EQ $true) {
            Write-Host "$($this.PointsLeftActual.CompositeActual[1].ToAnsiControlSequenceString())"
            $this.PointsLeftDataDirty = $false
        }
        If($this.AtkPromptDirty -EQ $true) {
            Write-Host "$($this.AtkPromptActual.ToAnsiControlSequenceString())"
            $this.AtkPromptDirty = $false
        }
        If($this.AtkDataDirty -EQ $true) {
            Write-Host "$($this.AtkPromptActual.CompositeActual[2].ToAnsiControlSequenceString())"
            $this.AtkDataDirty = $false
        }
        If($this.DefPromptDirty -EQ $true) {
            Write-Host "$($this.DefPromptActual.ToAnsiControlSequenceString())"
            $this.DefPromptDirty = $false
        }
        If($this.DefDataDirty -EQ $true) {
            Write-Host "$($this.DefPromptActual.CompositeActual[2].ToAnsiControlSequenceString())"
            $this.DefDataDirty = $false
        }
        If($this.MatPromptDirty -EQ $true) {
            Write-Host "$($this.MatPromptActual.ToAnsiControlSequenceString())"
            $this.MatPromptDirty = $false
        }
        If($this.MatDataDirty -EQ $true) {
            Write-Host "$($this.MatPromptActual.CompositeActual[2].ToAnsiControlSequenceString())"
            $this.MatDataDirty = $false
        }
        If($this.MdfPromptDirty -EQ $true) {
            Write-Host "$($this.MdfPromptActual.ToAnsiControlSequenceString())"
            $this.MdfPromptDirty = $false
        }
        If($this.MdfDataDirty -EQ $true) {
            Write-Host "$($this.MdfPromptActual.CompositeActual[2].ToAnsiControlSequenceString())"
            $this.MdfDataDirty = $false
        }
        If($this.SpdPromptDirty -EQ $true) {
            Write-Host "$($this.SpdPromptActual.ToAnsiControlSequenceString())"
            $this.SpdPromptDirty = $false
        }
        If($this.SpdDataDirty -EQ $true) {
            Write-Host "$($this.SpdPromptActual.CompositeActual[2].ToAnsiControlSequenceString())"
            $this.SpdDataDirty = $false
        }
        If($this.AccPromptDirty -EQ $true) {
            Write-Host "$($this.AccPromptActual.ToAnsiControlSequenceString())"
            $this.AccPromptDirty = $false
        }
        If($this.AccDataDirty -EQ $true) {
            Write-Host "$($this.AccPromptActual.CompositeActual[2].ToAnsiControlSequenceString())"
            $this.AccDataDirty = $false
        }
        If($this.LckPromptDirty -EQ $true) {
            Write-Host "$($this.LckPromptActual.ToAnsiControlSequenceString())"
            $this.LckPromptDirty = $false
        }
        If($this.LckDataDirty -EQ $true) {
            Write-Host "$($this.LckPromptActual.CompositeActual[2].ToAnsiControlSequenceString())"
            $this.LckDataDirty = $false
        }
    }
    
    [Void]HandleInput() {
        $KeyCap = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
        Switch($KeyCap.VirtualKeyCode) {
            37 { # LEFT ARROW
                $this.DecrementStatModVal(); Break
            }
            
            39 { # RIGHT ARROW
                $this.IncrementStatModVal(); Break
            }
            
            38 { # UP ARROW
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {}
                $this.CycleStateBackward()
                
                Break
            }
            
            40 { # DOWN ARROW
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {}
                $this.CycleStateForward()
                
                Break
            }
            
            13 { # ENTER
                $Script:ThePssSubstate = [PlayerSetupScreenStates]::PlayerSetupAffinitySelect
            }
            
            82 { # R
                # FORCE A RE-ROLL OF THE STATS
                # THIS NEEDS TO RESET ALL THE MOD POINTS AND POINT POOL BEFORE REGENERATING
                $this.PointsPool   = 10
                $this.AtkModPoints = 0
                $this.DefModPoints = 0
                $this.MatModPoints = 0
                $this.MdfModPoints = 0
                $this.SpdModPoints = 0
                $this.AccModPoints = 0
                $this.LckModPoints = 0
                $this.GenerateStats()
                $this.UpdatePointsLeftActual()
                $this.UpdateAtkPromptActual()
                $this.UpdateDefPromptActual()
                $this.UpdateMatPromptActual()
                $this.UpdateMdfPromptActual()
                $this.UpdateSpdPromptActual()
                $this.UpdateAccPromptActual()
                $this.UpdateLckPromptActual()
                
                Break
            }
        }
    }
}
