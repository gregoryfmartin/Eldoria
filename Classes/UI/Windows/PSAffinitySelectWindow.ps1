using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# PS AFFINITY SELECT WINDOW
#
# THIS WINDOW ALLOWS THE USER TO SELECT THEIR DESIRED AFFINITY.
#
###############################################################################

Class PSAffinitySelectWindow : WindowBase {
    Static [Int]$WindowLTRow = 5
    Static [Int]$WindowLTColumn = 25
    Static [Int]$WindowRBRow = 13
    Static [Int]$WindowRBColumn = 38
    
    Static [String]$ChevronData = '❱'
    Static [String]$ChevronBlankData = ' '
    Static [String]$AffinityNameBlankData = ' ' * 7
    Static [String]$WindowTitle = ' Affinity'
    
    Static [String[]]$AffinityLabelData = @(
        'Fire',
        'Water',
        'Earth',
        'Wind',
        'Light',
        'Dark',
        'Ice'
    )
    
    [Int]$ActiveChevronIndex
    
    [Boolean]$ChevronDirty
    [Boolean]$AffinityListDirty
    [Boolean]$ActiveItemBlinking
    [Boolean]$IsActive
    [Boolean]$HasBorderBeenRedrawn
    
    [List[ValueTuple[[ATString], [Boolean]]]]$ChevronsActual
    [List[ATStringComposite]]$AffinityLabelsActual
    [List[ATString]]$AffinityLabelBlanksActual
    [List[ATString]]$ChevronBlanksActual
    
    PSAffinitySelectWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row = [PSAffinitySelectWindow]::WindowLTRow
            Column = [PSAffinitySelectWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row = [PSAffinitySelectWindow]::WindowRBRow
            Column = [PSAffinitySelectWindow]::WindowRBColumn
        }
        
        $this.UpdateDimensions()
        $this.SetupTitle([PSAffinitySelectWindow]::WindowTitle, [CCTextDefault24]::new())
        
        $this.ActiveChevronIndex = 0
        $this.ChevronDirty = $true
        $this.AffinityListDirty = $true
        $this.ActiveItemBlinking = $false
        $this.IsActive = $false
        $this.HasBorderBeenRedrawn = $false
        
        $this.CreateChevrons()
        $this.CreateChevronBlanks()
        $this.CreateAffinityLabels()
        $this.CreateAffinityLabelBlanks()
    }
    
    [Void]CreateChevrons() {
        $this.ChevronsActual = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        For([Int]$I = 0; $I -LT [PSAffinitySelectWindow]::AffinityLabelData.Count; $I++) {
            $this.ChevronsActual.Add(
                [ValueTuple]::Create(
                    [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                            Coordinates = [ATCoordinates]@{
                                Row = ($this.LeftTop.Row + 1) + $I
                                Column = $this.LeftTop.Column + 2
                            }
                        }
                        UserData = "$([PSAffinitySelectWindow]::ChevronData)"
                        UseATReset = $true
                    },
                    $false
                )
            )
        }
        
        $ChevCopy = $this.ChevronsActual[0]
        $this.ChevronsActual[0] = [ValueTuple]::Create($ChevCopy.Item1, $true)
    }
    
    [Void]CreateChevronBlanks() {
        $this.ChevronBlanksActual = [List[ATString]]::new()
        For([Int]$I = 0; $I -LT [PSAffinitySelectWindow]::AffinityLabelData.Count; $I++) {
            $this.ChevronBlanksActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        Coordinates = [ATCoordinates]@{
                            Row = ($this.LeftTop.Row + 1) + $I
                            Column = $this.LeftTop.Column + 2
                        }
                    }
                    UserData = "$([PSAffinitySelectWindow]::ChevronBlankData)"
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]CreateAffinityLabels() {
        $this.AffinityLabelsActual = [List[ATStringComposite]]::new()
        
        $this.AffinityLabelsActual.Add([ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[[BattleActionType]::ElementalFire].Item2
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 1
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = "$($Script:BATAdornmentCharTable[[BattleActionType]::ElementalFire].Item1)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' Fire'
                UseATReset = $true
            }
        )))
        
        $this.AffinityLabelsActual.Add([ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[[BattleActionType]::ElementalWater].Item2
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 2
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = "$($Script:BATAdornmentCharTable[[BattleActionType]::ElementalWater].Item1)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' Water'
                UseATReset = $true
            }
        )))
        
        $this.AffinityLabelsActual.Add([ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[[BattleActionType]::ElementalEarth].Item2
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 3
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = "$($Script:BATAdornmentCharTable[[BattleActionType]::ElementalEarth].Item1)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' Earth'
                UseATReset = $true
            }
        )))
        
        $this.AffinityLabelsActual.Add([ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[[BattleActionType]::ElementalWind].Item2
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 4
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = "$($Script:BATAdornmentCharTable[[BattleActionType]::ElementalWind].Item1)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' Wind'
                UseATReset = $true
            }
        )))
        
        $this.AffinityLabelsActual.Add([ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[[BattleActionType]::ElementalLight].Item2
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 5
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = "$($Script:BATAdornmentCharTable[[BattleActionType]::ElementalLight].Item1)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' Light'
                UseATReset = $true
            }
        )))
        
        $this.AffinityLabelsActual.Add([ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[[BattleActionType]::ElementalDark].Item2
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 6
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = "$($Script:BATAdornmentCharTable[[BattleActionType]::ElementalDark].Item1)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' Dark'
                UseATReset = $true
            }
        )))
        
        $this.AffinityLabelsActual.Add([ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[[BattleActionType]::ElementalIce].Item2
                    Coordinates = [ATCoordinates]@{
                        Row = $this.LeftTop.Row + 7
                        Column = $this.LeftTop.Column + 4
                    }
                }
                UserData = "$($Script:BATAdornmentCharTable[[BattleActionType]::ElementalIce].Item1)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' Ice'
                UseATReset = $true
            }
        )))
    }
    
    [Void]CreateAffinityLabelBlanks() {
        $this.AffinityLabelBlanksActual = [List[ATString]]::new()
        For([Int]$I = 0; $I -LT [PSAffinitySelectWindow]::AffinityLabelData.Count; $I++) {
            $this.AffinityLabelBlanksActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        Coordinates = [ATCoordinates]@{
                            Row = ($this.LeftTop.Row + 1) + $I
                            Column = $this.LeftTop.Column + 5
                        }
                    }
                    UserData = "$([PSAffinitySelectWindow]::AffinityNameBlankData)"
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]Draw() {
        If($this.IsActive -EQ $true) {
            If($this.HasBorderBeenRedrawn -EQ $false) {
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
                $this.TitleDirty = $true
                $this.HasBorderBeenRedrawn = $true
            }
        } Else {
            If($this.HasBorderBeenRedrawn -EQ $false) {
                $this.BorderDrawColors = [ConsoleColor24[]](
                    [CCTextDefault24]::new(),
                    [CCTextDefault24]::new(),
                    [CCTextDefault24]::new(),
                    [CCTextDefault24]::new(),
                    [CCTextDefault24]::new(),
                    [CCTextDefault24]::new(),
                    [CCTextDefault24]::new(),
                    [CCTextDefault24]::new()
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
                $this.TitleDirty = $true
                $this.HasBorderBeenRedrawn = $true
            }
        }
        
        ([WindowBase]$this).Draw()
        
        If($this.AffinityListDirty -EQ $true) {
            For([Int]$I = 0; $I -LT [PSAffinitySelectWindow]::AffinityLabelData.Count; $I++) {
                Write-Host "$($this.AffinityLabelBlanksActual[$I].ToAnsiControlSequenceString())$($this.AffinityLabelsActual[$I].ToAnsiControlSequenceString())"
            }
            
            $this.AffinityListDirty = $false
        }
        
        If($this.ChevronDirty -EQ $true) {
            For([Int]$I = 0; $I -LT [PSAffinitySelectWindow]::AffinityLabelData.Count; $I++) {
                If($this.ChevronsActual[$I].Item2 -EQ $true) {
                    Write-Host "$($this.ChevronBlanksActual[$I].ToAnsiControlSequenceString())$($this.ChevronsActual[$I].Item1.ToAnsiControlSequenceString())"
                } Else {
                    Write-Host "$($this.ChevronBlanksActual[$I].ToAnsiControlSequenceString())"
                }
            }
            
            $this.ChevronDirty = $false
        }
    }
    
    [Void]HandleInput() {
        $KeyCap = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
        
        Switch($KeyCap.VirtualKeyCode) {
            38 { # UP ARROW
                $CurChev = $this.ChevronsActual[$this.ActiveChevronIndex]
                $this.ChevronsActual[$this.ActiveChevronIndex] = [ValueTuple]::Create($CurChev.Item1, $false)
                
                If($this.ActiveChevronIndex -EQ 0) {
                    $this.ActiveChevronIndex = [PSAffinitySelectWindow]::AffinityLabelData.Count - 1
                } Else {
                    $this.ActiveChevronIndex--
                }
                
                $CurChev = $this.ChevronsActual[$this.ActiveChevronIndex]
                $this.ChevronsActual[$this.ActiveChevronIndex] = [ValueTuple]::Create($CurChev.Item1, $true)
                
                $this.ChevronDirty = $true
                    
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {}
                
                Break
            }
                
            40 { # DOWN ARROW
                $CurChev = $this.ChevronsActual[$this.ActiveChevronIndex]
                $this.ChevronsActual[$this.ActiveChevronIndex] = [ValueTuple]::Create($CurChev.Item1, $false)
                    
                If($this.ActiveChevronIndex -EQ ([PSAffinitySelectWindow]::AffinityLabelData.Count - 1)) {
                    $this.ActiveChevronIndex = 0
                } Else {
                    $this.ActiveChevronIndex++
                }
                    
                $CurChev = $this.ChevronsActual[$this.ActiveChevronIndex]
                $this.ChevronsActual[$this.ActiveChevronIndex] = [ValueTuple]::Create($CurChev.Item1, $true)
                    
                $this.ChevronDirty = $true
                    
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {}
                    
                Break
            }
                
            13 { # ENTER
                If($Script:ThePSProfileSelectWindow -NE $null) {
                    $Script:ThePSProfileSelectWindow.IsActive = $true
                    $Script:ThePSProfileSelectWindow.HasBorderBeenRedrawn = $false
                }
        
                $Script:ThePssSubstate = [PlayerSetupScreenStates]::PlayerSetupProfileSelect
                    
                Break
            }
            
            27 { # ESCAPE
                $Script:ThePssSubstate = [PlayerSetupScreenStates]::PlayerSetupPointAllocate
                
                Break
            }
        }
    }
}
