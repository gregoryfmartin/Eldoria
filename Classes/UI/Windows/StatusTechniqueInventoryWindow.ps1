using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# STATUS TECHNIQUE INVENTORY WINDOW
#
###############################################################################

Class StatusTechniqueInventoryWindow : WindowBase {
    Static [Int]$WindowLTRow    = 4
    Static [Int]$WindowLTColumn = 22
    Static [Int]$WindowRBRow    = 16
    Static [Int]$WindowRBColumn = 80

    Static [String]$IChevronCharacter           = '❱'
    Static [String]$IChevronCharacterBlank      = ' '
    Static [String]$PagingChevronRightCharacter = "`u{1433}"
    Static [String]$PagingChevronLeftCharacter  = "`u{1438}"
    Static [String]$PagingChevronBlankCharacter = ' '
    Static [String]$DivLineHorizontalString     = '─────────────────────────────────────────────────────────'
    Static [String]$ZpLineBlank                 = '                                                         '
    Static [String]$DescLineBlank               = '                                                         '
    Static [String]$ZeroPagePrompt              = 'You have no techniques in your inventory.'
    Static [String]$WindowTitle                 = 'Inventory'

    Static [ATString]$PagingChevronRight = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCAppleYellowLight24]::new()
        }
        UserData   = "$([StatusTechniqueInventoryWindow]::PagingChevronRightCharacter)"
        UseATReset = $true
    }
    Static [ATString]$PagingChevronLeft = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCAppleYellowLight24]::new()
        }
        UserData   = "$([StatusTechniqueInventoryWindow]::PagingChevronLeftCharacter)"
        UseATReset = $true
    }
    Static [ATString]$PagingChevronRightBlank = [ATStringNone]::new()
    Static [ATString]$PagingChevronLeftBlank = [ATStringNone]::new()
    Static [ATString]$DivLineHorizontal = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCTextDefault24]::new()
        }
        UserData   = "$([StatusTechniqueInventoryWindow]::DivLineHorizontalString)"
        UseATReset = $true
    }

    Static [Boolean]$DebugMode = $false

    [Int]$ItemsPerPage
    [Int]$NumPages
    [Int]$CurrentPage
    [Int]$ActiveIChevronIndex
    [Boolean]$PlayerChevronDirty
    [Boolean]$PagingChevronRightDirty
    [Boolean]$PagingChevronLeftDirty
    [Boolean]$ItemsListDirty
    [Boolean]$CurrentPageDirty
    [Boolean]$PlayerChevronVisible
    [Boolean]$PagingChevronRightVisible
    [Boolean]$PagingChevronLeftVisible
    [Boolean]$ZeroPageActive
    [Boolean]$BookDirty
    [Boolean]$ActiveItemBlinking
    [Boolean]$DivLineDirty
    [Boolean]$ItemDescDirty
    [Boolean]$ZpBlankedDirty
    [Boolean]$ZpPromptDirty
    [Boolean]$IsActive
    [Boolean]$IsBlanked
    [List[ATString]]$ItemLabels
    [List[ATString]]$ItemLabelBlanks
    [List[BattleAction]]$PageRefs
    [List[ValueTuple[[ATString], [Boolean]]]]$IChevrons

    StatusTechniqueInventoryWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [StatusTechniqueInventoryWindow]::WindowLTRow
            Column = [StatusTechniqueInventoryWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [StatusTechniqueInventoryWindow]::WindowRBRow
            Column = [StatusTechniqueInventoryWindow]::WindowRBColumn
        }

        $this.UpdateDimensions()

        $this.SetupTitle([StatusTechniqueInventoryWindow]::WindowTitle, [CCTextDefault24]::new())

        $this.ItemsPerPage              = 10
        $this.NumPages                  = 1
        $this.CurrentPage               = 1
        $this.ActiveIChevronIndex       = 0
        $this.PlayerChevronDirty        = $true
        $this.PagingChevronRightDirty   = $true
        $this.PagingChevronLeftDirty    = $true
        $this.ItemsListDirty            = $true
        $this.CurrentPageDirty          = $true
        $this.PlayerChevronVisible      = $true
        $this.PagingChevronRightVisible = $false
        $this.PagingChevronLeftVisible  = $false
        $this.ZeroPageActive            = $false
        $this.BookDirty                 = $true
        $this.ActiveItemBlinking        = $false
        $this.DivLineDirty              = $true
        $this.ItemDescDirty             = $true
        $this.ZpBlankedDirty            = $true
        $this.ZpPromptDirty             = $true
        $this.IsActive                  = $false
        $this.IsBlanked                 = $false
        $this.PageRefs                  = $null

        $this.CreateIChevrons()
        $this.ConfigurePagingChevrons()
        $this.ConfigureDivLine()
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.IsActive -EQ $true) {
            $this.IsBlanked = $false
            If($this.BookDirty -EQ $true) {
                $this.CalculateNumPages()
                $this.BookDirty = $false
            }
            If($this.CurrentPageDirty -EQ $true) {
                $this.PopulatePage()
            }
            If($this.ZeroPageActive -EQ $true) {
                $this.WriteZeroInventoryPage()
            } Else {
                If($this.DivLineDirty -EQ $true) {
                    Write-Host "$([StatusTechniqueInventoryWindow]::DivLineHorizontal.ToAnsiControlSequenceString())"
                    $this.DivLineDirty = $false
                }
                If($this.PlayerChevronVisible -EQ $true -AND $this.PlayerChevronDirty -EQ $true) {
                    Foreach($ic in $this.IChevrons) {
                        Write-Host "$($ic.Item1.ToAnsiControlSequenceString())"
                    }
                    $this.PlayerChevronDirty = $false
                }
                If($this.NumPages -GT 1) {
                    If($this.CurrentPage -EQ 1) {
                        If($this.PagingChevronLeftVisible -EQ $true) {
                            Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronLeftBlank.ToAnsiControlSequenceString())"
                            $this.PagingChevronLeftVisible = $false
                            $this.PagingChevronLeftDirty   = $true
                        }
                        If($this.PagingChevronRightVisible -EQ $false) {
                            $this.PagingChevronRightVisible = $true
                        }
                        If(($this.PagingChevronRightVisible -EQ $true) -AND ($this.PagingChevronRightDirty -EQ $true)) {
                            Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronRight.ToAnsiControlSequenceString())"
                            $this.PagingChevronRightDirty = $false
                        }
                    } Elseif(($this.CurrentPage -GT 1) -AND ($this.CurrentPage -LT $this.NumPages)) {
                        If($this.PagingChevronLeftVisible -EQ $false) {
                            $this.PagingChevronLeftVisible = $true
                        }
                        If($this.PagingChevronRightVisible -EQ $false) {
                            $this.PagingChevronRightVisible = $true
                        }
                        If(($this.PagingChevronRightVisible -EQ $true) -AND ($this.PagingChevronRightDirty -EQ $true)) {
                            Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronLeft.ToAnsiControlSequenceString())"
                            $this.PagingChevronRightDirty = $false
                        }
                        If(($this.PagingChevronLeftVisible -EQ $true) -AND ($this.PagingChevronLeftDirty -EQ $true)) {
                            Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronRight.ToAnsiControlSequenceString())"
                            $this.PagingChevronLeftDirty = $false
                        }
                    } Elseif($this.CurrentPage -GE $this.NumPages) {
                        If($this.PagingChevronRightVisible -EQ $true) {
                            Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronRightBlank.ToAnsiControlSequenceString())"
                            $this.PagingChevronRightVisible = $false
                            $this.PagingChevronRightDirty   = $true
                        }
                        If($this.PagingChevronLeftVisible -EQ $false) {
                            $this.PagingChevronLeftVisible = $true
                        }
                        If(($this.PagingChevronLeftVisible -EQ $true) -AND ($this.PagingChevronLeftDirty -EQ $true)) {
                            Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronLeft.ToAnsiControlSequenceString())"
                            $this.PagingChevronLeftDirty = $false
                        }
                    }
                } Elseif($this.NumPages -EQ 1) {
                    If($this.PagingChevronLeftVisible -EQ $true) {
                        $this.PagingChevronLeftVisible = $false
                    }
                    If($this.PagingChevronRightVisible -EQ $true) {
                        $this.PagingChevronRightVisible = $false
                    }
                    If($this.PagingChevronLeftVisible -EQ $false) {
                        Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronLeftBlank.ToAnsiControlSequenceString())"
                    }
                    If($this.PagingChevronRightVisible -EQ $false) {
                        Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronRightBlank.ToAnsiControlSequenceString())"
                    }
                }
                If($this.ActiveItemBlinking -EQ $false) {
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCListItemCurrentHighlight24]::new()
                    $this.ItemsListDirty                                               = $true
                    $this.ActiveItemBlinking                                           = $true
                }
                If($this.ItemsListDirty -EQ $true) {
                    $this.WriteItemLabels()
                    Write-Host "$([ATControlSequences]::CursorHide)"
                    $this.ItemsListDirty = $false
                }
                If($this.ItemDescDirty -EQ $true) {
                    [ATStringComposite]$a = [ATStringComposite]::new(@(
                        [ATString]@{
                            Prefix = [ATStringPrefix]@{
                                ForegroundColor = [CCTextDefault24]::new()
                                Coordinates     = [ATCoordinates]@{
                                    Row    = $this.RightBottom.Row - 3
                                    Column = $this.LeftTop.Column + 1
                                }
                            }
                            UserData   = "$([StatusTechniqueInventoryWindow]::DescLineBlank)"
                            UseATReset = $true
                        },
                        [ATString]@{
                            Prefix = [ATStringPrefix]@{
                                ForegroundColor = [CCTextDefault24]::new()
                                Coordinates     = [ATCoordinates]@{
                                    Row    = $this.RightBottom.Row - 3
                                    Column = $this.LeftTop.Column + 2
                                }
                            }
                            UserData   = "$($this.PageRefs[$this.ActiveIChevronIndex].Description)"
                            UseATReset = $true
                        },
                        [ATString]@{
                            Prefix = [ATStringPrefix]@{
                                ForegroundColor = [CCTextDefault24]::new()
                                Coordinates     = [ATCoordinates]@{
                                    Row    = $this.RightBottom.Row - 1
                                    Column = $this.LeftTop.Column + 1
                                }
                            }
                            UserData   = "$([StatusTechniqueInventoryWindow]::DescLineBlank)"
                            UseATReset = $true
                        },
                        [ATString]@{
                            Prefix = [ATStringPrefix]@{
                                ForegroundColor = [CCTextDefault24]::new()
                                Coordinates     = [ATCoordinates]@{
                                    Row    = $this.RightBottom.Row - 1
                                    Column = $this.LeftTop.Column + 2
                                }
                            }
                            UserData = 'AFF: '
                        },
                        [ATString]@{
                            Prefix = [ATStringPrefix]@{
                                ForegroundColor = $Script:BATAdornmentCharTable[$this.PageRefs[$this.ActiveIChevronIndex].Type].Item2
                            }
                            UserData   = "$($Script:BATAdornmentCharTable[$this.PageRefs[$this.ActiveIChevronIndex].Type].Item1)"
                            UseATReset = $true
                        },
                        [ATString]@{
                            Prefix = [ATStringPrefix]@{
                                ForegroundColor = [CCTextDefault24]::new()
                            }
                            UserData   = "   PWR: $($this.PageRefs[$this.ActiveIChevronIndex].EffectValue)   MP COST: $("{0:d2}" -F $this.PageRefs[$this.ActiveIChevronIndex].MpCost)   CHANCE: $("{0:f0}" -F ($this.PageRefs[$this.ActiveIChevronIndex].Chance * 100))%"
                            UseATReset = $true
                        }
                    ))
                    Write-Host "$($a.ToAnsiControlSequenceString())"
                }
            }
        } Else {
            If($this.IsBlanked -EQ $false) {
                Foreach($Row in 5..15) {
                    [ATString]$a = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            Coordinates = [ATCoordinates]@{
                                Row    = $Row
                                Column = $this.LeftTop.Column + 1
                            }
                        }
                        UserData   = "$([StatusTechniqueInventoryWindow]::ZpLineBlank)"
                        UseATReset = $true
                    }
                    Write-Host "$($a.ToAnsiControlSequenceString())"
                }
                $this.IsBlanked = $true
            }
        }
    }

    [Void]CreateIChevrons() {
        $this.IChevrons = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 2
                        Column = $this.LeftTop.Column + 1
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacter)"
                UseATReset = $true
            },
            $true
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 3
                        Column = $this.LeftTop.Column + 1
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 4
                        Column = $this.LeftTop.Column + 1
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 5
                        Column = $this.LeftTop.Column + 1
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 6
                        Column = $this.LeftTop.Column + 1
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 2
                        Column = $this.RightBottom.Column - 17
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 3
                        Column = $this.RightBottom.Column - 17
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 4
                        Column = $this.RightBottom.Column - 17
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 5
                        Column = $this.RightBottom.Column - 17
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 6
                        Column = $this.RightBottom.Column - 17
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
    }

    [Void]CreateItemLabels() {
        $this.ItemLabels = [List[ATString]]::new()
        [Int]$c = 0

        Foreach($i in $this.PageRefs) {
            $this.ItemLabels.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.IChevrons[$c].Item1.Prefix.Coordinates.Row
                            Column = $this.IChevrons[$c].Item1.Prefix.Coordinates.Column + 2
                        }
                    }
                    UserData   = "$($i.Name)"
                    UseATReset = $true
                }
            )
            $c++ # TOTALLY A PROGRAMMER JOKE
        }
        $this.ResetIChevronPositions()
        $this.CreateItemLabelBlanks()
    }

    [Void]CreateItemLabelBlanks() {
        $this.ItemLabelBlanks = [List[ATString]]::new()
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 2
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 3
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 4
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 5
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 6
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 2
                        Column = $this.RightBottom.Column - 16
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 3
                        Column = $this.RightBottom.Column - 16
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 4
                        Column = $this.RightBottom.Column - 16
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 5
                        Column = $this.RightBottom.Column - 16
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 6
                        Column = $this.RightBottom.Column - 16
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
    }

    [Void]CalculateNumPages() {
        $pp = $Script:ThePlayer.ActionInventory.Listing.Count / $this.ItemsPerPage
        If($pp -LT 1) {
            $this.NumPages = 1
        } Else {
            $this.NumPages = [Math]::Ceiling($pp)
        }
        If($this.CurrentPage -GT $this.NumPages) {
            $this.CurrentPage = $this.NumPages
        }
    }

    [Void]TurnPageForward() {
        If(($this.CurrentPage + 1) -LE $this.NumPages) {
            $this.CurrentPage++
            $this.CurrentPageDirty   = $true
            $this.ActiveItemBlinking = $false
            $this.ItemDescDirty      = $true
        }
    }

    [Void]TurnPageBackward() {
        If(($this.CurrentPage - 1) -GE 1) {
            $this.CurrentPage--
            $this.CurrentPageDirty   = $true
            $this.ActiveItemBlinking = $false
            $this.ItemDescDirty      = $true
        }
    }

    [Void]PopulatePage() {
        If($Script:ThePlayer.ActionInventory.Listing.Count -LE 0) {
            $this.ZeroPageActive   = $true
            $this.CurrentPageDirty = $false
            $this.ZpPromptDirty    = $true
            $this.ZpBlankedDirty   = $true
        } Else {
            $this.PageRefs       = [List[BattleAction]]::new()
            $this.ZeroPageActive = $false
            $rs                  = (($this.CurrentPage * $this.ItemsPerPage) - $this.ItemsPerPage)
            $rs                  = [Math]::Clamp($rs, 0, [Int]::MaxValue)
            $re                  = 10
            
            Try {
                $this.PageRefs = $Script:ThePlayer.ActionInventory.Listing.GetRange($rs, $re)
            } Catch {
                $this.PageRefs = $Script:ThePlayer.ActionInventory.Listing.GetRange($rs, ($Script:ThePlayer.ActionInventory.Listing.Count - $rs))
            }
            $this.CreateItemLabels()
            $this.ItemsListDirty   = $true
            $this.CurrentPageDirty = $false
        }
    }

    [Void]WriteItemLabels() {
        Foreach($i in $this.ItemLabelBlanks) {
            Write-Host "$($i.ToAnsiControlSequenceString())"
        }
        Foreach($i in $this.ItemLabels) {
            Write-Host "$($i.ToAnsiControlSequenceString())"
        }
    }

    [ATString]GetActiveIChevron() {
        $this.ActiveIChevronIndex = 0

        Foreach($a in $this.IChevrons) {
            If($a.Item2 -EQ $true) {
                Return $a.Item1
            }
            $this.ActiveIChevronIndex++
        }
        $this.ActiveIChevronIndex                        = 0
        $this.IChevrons[$this.ActiveIChevronIndex].Item2 = $true

        Return $this.IChevrons[$this.ActiveIChevronIndex].Item1
    }

    [Void]WriteZeroInventoryPage() {
        If($this.ZpBlankedDirty -EQ $true) {
            Foreach($a in 5..15) {
                [ATString]$b = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        BackgroundColor = [CCAppleBlueDark24]::new()
                        Coordinates = [ATCoordinates]@{
                            Row    = $a
                            Column = $this.LeftTop.Column + 1
                        }
                    }
                    UserData   = "$([StatusTechniqueInventoryWindow]::ZpLineBlank)"
                    UseATReset = $true
                }
                Write-Host "$($b.ToAnsiControlSequenceString())"
            }
            $this.ZpBlankedDirty = $false
        }
        If($this.ZpPromptDirty -EQ $true) {
            [ATString]$a = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + ($this.Height / 2)
                        Column = $this.LeftTop.Column + (($this.Width / 2) - ([StatusTechniqueInventoryWindow]::ZeroPagePrompt.Length / 2))
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::ZeroPagePrompt)"
                UseATReset = $true
            }
            Write-Host "$($a.ToAnsiControlSequenceString())"
            $this.ZpPromptDirty = $false
        }
    }

    [Void]WriteMoronPage() {}

    [Void]ResetIChevronPositions() {
        $this.IChevrons[$this.ActiveIChevronIndex].Item2          = $false
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
        Try {
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Catch {}
        $this.ActiveIChevronIndex                                      = 0
        $this.IChevrons[$this.ActiveIChevronIndex].Item2               = $true
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData      = "$([StatusTechniqueInventoryWindow]::IChevronCharacter)"
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations = [ATDecoration]@{
            Blink = $true
        }
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
        $this.PlayerChevronDirty                                           = $true
        $this.ActiveItemBlinking                                           = $false
        $this.ItemDescDirty                                                = $true
    }

    [Void]HandleInput() {
        $keyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')
        Switch($keyCap.VirtualKeyCode) {
            13 {
                $Script:StatusIsSelected      = $this.PageRefs[$this.ActiveIChevronIndex]
                [BattleAction]$EquippedAction = $Script:ThePlayer.ActionListing[$Script:StatusEsSelectedSlot]
                If($null -EQ $EquippedAction) {
                    $Script:ThePlayer.ActionListing[$Script:StatusEsSelectedSlot] = [BattleAction]::new($Script:StatusIsSelected)
                    $Script:ThePlayer.ActionInventory.RemoveActionByName($Script:StatusIsSelected.Name)
                } Else {
                    [Int]$RootCollectionIndex = $this.CurrentPage -EQ 1 ? $this.ActiveIChevronIndex : ((($this.CurrentPage - 1) * $this.ItemsPerPage) + $this.ActiveIChevronIndex)
                    $Script:ThePlayer.ActionListing[$Script:StatusEsSelectedSlot]   = [BattleAction]::new($Script:StatusIsSelected)
                    $Script:ThePlayer.ActionInventory.Listing[$RootCollectionIndex] = [BattleAction]::new($EquippedAction)
                }
                $Script:StatusScreenMode = [StatusScreenMode]::EquippedTechSelection
            }

            27 {
                $Script:StatusScreenMode = [StatusScreenMode]::EquippedTechSelection
            }

            38 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up.'
                }
                If(($this.ActiveIChevronIndex -1) -GE 0) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex--
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacter)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
                $this.DivLineDirty       = $true
            }

            40 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up.'
                }
                If(($this.ActiveIChevronIndex + 1) -LT $this.PageRefs.Count) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex++
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacter)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
                $this.DivLineDirty       = $true
            }

            39 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up.'
                }
                If(($this.ActiveIChevronIndex + 5) -LT $this.PageRefs.Count) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex += 5
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacter)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
                $this.DivLineDirty       = $true
            }

            37 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up.'
                }
                If(($this.ActiveIChevronIndex - 5) -GE 0) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex -= 5
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacter)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
                $this.DivLineDirty       = $true
            }

            68 {
                $this.TurnPageForward()
            }

            65 {
                $this.TurnPageBackward()
            }
        }
    }

    [Void]ConfigurePagingChevrons() {
        [StatusTechniqueInventoryWindow]::PagingChevronRight.Prefix.Coordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 1
            Column = $this.RightBottom.Column - 2
        }
        [StatusTechniqueInventoryWindow]::PagingChevronRightBlank = [ATString]@{
            Prefix     = [ATStringPrefix]::new()
            UserData   = ' '
            UseATReset = $true
        }
        [StatusTechniqueInventoryWindow]::PagingChevronRightBlank.Prefix.Coordinates = [ATCoordinates]::new([StatusTechniqueInventoryWindow]::PagingChevronRight.Prefix.Coordinates)
        [StatusTechniqueInventoryWindow]::PagingChevronLeft.Prefix.Coordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 1
            Column = $this.LeftTop.Column + 2
        }
        [StatusTechniqueInventoryWindow]::PagingChevronLeftBlank = [ATString]@{
            Prefix     = [ATStringPrefix]::new()
            UserData   = ' '
            UseATReset = $true
        }
        [StatusTechniqueInventoryWindow]::PagingChevronLeftBlank.Prefix.Coordinates = [ATCoordinates]::new([StatusTechniqueInventoryWindow]::PagingChevronLeft.Prefix.Coordinates)
    }

    [Void]ConfigureDivLine() {
        [StatusTechniqueInventoryWindow]::DivLineHorizontal.Prefix.Coordinates = [ATCoordinates]@{
            Row    = $this.RightBottom.Row - 4
            Column = $this.LeftTop.Column + 1
        }
    }

    [Void]SetFlagsDirty() {
        $this.BookDirty        = $true
        $this.CurrentPageDirty = $true
        $this.DivLineDirty     = $true
        $this.CurrentPage      = 1
    }
}

