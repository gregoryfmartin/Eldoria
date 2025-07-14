using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# INVENTORY WINDOW
#
# AS WITH OTHER CLASSES, THE NAME OF THIS CLASS IS A BIT OF A MISNOMER.
# SPECIFICALLY, THIS CLASS INCORPORATES MULTIPLE WINDOWS TOGETHER INTO A SINGLE
# SCREEN. ALSO, THIS INVENTORY COVERS THE PLAYER'S ITEM INVENTORY AND NOT THE
# BATTLE ACTION INVENTORY, SO THERE'S A BIT TO BE DESIRED HERE. THIS WILL BE
# WORKED ON AFTER COVERAGE IS COMPLETED.
#
###############################################################################

Class InventoryWindow : WindowBase {
    Static [Int]$WindowLTRow    = 1
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowBRRow    = 20
    Static [Int]$WindowBRColumn = 79

    Static [String]$WindowTitle = 'Inventory'

    Static [String]$IChevronCharacter           = '❱'
    Static [String]$IChevronBlankCharacter      = ' '
    Static [String]$PagingChevronRightCharacter = "`u{1433}"
    Static [String]$PagingChevronLeftCharacter  = "`u{1438}"
    Static [String]$PagingChevronBlankCharater  = ' '

    Static [String]$DivLineHorizontalString = '─────────────────────────────────────────────────────────────────────────────'
    Static [String]$ZpLineBlank             = '                                                                             '
    Static [String]$DescLineBlank           = '                                                                          '
    Static [String]$ItemLabelBlank          = '               '

    Static [ATString]$PagingChevronRight = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCAppleYellowLight24]::new()
            Coordinates     = [ATCoordinates]@{
                Row    = 2
                Column = 77
            }
        }
        UserData   = "$([InventoryWindow]::PagingChevronRightCharacter)"
        UseATReset = $true
    }
    Static [ATString]$PagingChevronLeft = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCAppleYellowLight24]::new()
            Coordinates     = [ATCoordinates]@{
                Row    = 2
                Column = 3
            }
        }
        UserData   = "$([InventoryWindow]::PagingChevronLeftCharacter)"
        UseATReset = $true
    }
    Static [ATString]$PagingChevronRightBlank = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCAppleMintLight24]::new()
            Coordinates     = [ATCoordinates]@{
                Row    = 2
                Column = 77
            }
        }
        UserData   = "$([InventoryWindow]::PagingChevronBlankCharater)"
        UseATReset = $true
    }
    Static [ATString]$PagingChevronLeftBlank = [ATString]@{
        Prefix = [ATStringPrefix]@{
            Coordinates = [ATCoordinates]@{
                Row    = 2
                Column = 3
            }
        }
        UserData   = "$([InventoryWindow]::PagingChevronBlankCharater)"
        UseATReset = $true
    }
    Static [ATString]$DivLineHorizontal = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCTextDefault24]::new()
            Coordinates     = [ATCoordinates]@{
                Row    = 13
                Column = 2
            }
        }
        UserData   = "$([InventoryWindow]::DivLineHorizontalString)"
        UseATReset = $true
    }

    Static [Boolean]$DebugMode     = $false
    Static [Int]$MoronCounter      = 0
    Static [String]$ZeroPagePrompt = 'You have no items in your inventory.'

    [Boolean]$PlayerChevronDirty
    [Boolean]$PagingChevronRightDirty
    [Boolean]$PagingChevronLeftDirty
    [Boolean]$ItemsListDirty
    [Boolean]$CurrentPageDirty
    [Boolean]$PlayerChevronVisible
    [Boolean]$PagingChevronRightVisible
    [Boolean]$PagingChevronLeftVisible
    [Boolean]$ZeroPageActive
    [Boolean]$MoronPageActive
    [Boolean]$BookDirty
    [Boolean]$ActiveItemBlinking
    [Boolean]$DivLineDirty
    [Boolean]$ItemDescDirty
    [Boolean]$ZpBlankedDirty
    [Boolean]$ZpPromptDirty

    [Int]$ItemsPerPage
    [Int]$NumPages
    [Int]$CurrentPage
    [Int]$ActiveIChevronIndex
    [List[MapTileObject]]$PageRefs
    [List[ValueTuple[[ATString], [Boolean]]]]$IChevrons
    [List[ATString]]$ItemLabels
    [List[ATString]]$ItemLabelBlanks

    InventoryWindow() : base() {
        $this.LeftTop          = [ATCoordinates]@{
            Row    = [InventoryWindow]::WindowLTRow
            Column = [InventoryWindow]::WindowLTColumn
        }
        $this.RightBottom      = [ATCoordinates]@{
            Row    = [InventoryWindow]::WindowBRRow
            Column = [InventoryWindow]::WindowBRColumn
        }

        $this.UpdateDimensions()
        $this.SetupTitle([InventoryWindow]::WindowTitle, [CCTextDefault24]::new())

        $this.PlayerChevronDirty        = $true
        $this.PagingChevronRightDirty   = $true
        $this.PagingChevronLeftDirty    = $true
        $this.ItemsListDirty            = $true
        $this.CurrentPageDirty          = $true
        $this.PlayerChevronVisible      = $true
        $this.PagingChevronRightVisible = $false
        $this.PagingChevronLeftVisible  = $false
        $this.ZeroPageActive            = $false
        $this.MoronPageActive           = $false
        $this.BookDirty                 = $true
        $this.ActiveItemBlinking        = $false
        $this.DivLineDirty              = $true
        $this.ItemDescDirty             = $true
        $this.ZpBlankedDirty            = $true
        $this.ZpPromptDirty             = $true
        $this.ItemsPerPage              = 10
        $this.NumPages                  = 1
        $this.CurrentPage               = 1
        $this.PageRefs                  = [List[MapTileObject]]::new()

        $this.CreateIChevrons()
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.BookDirty -EQ $true) {
            $this.CalculateNumPages()
            $this.BookDirty = $false
        }
        If($this.CurrentPageDirty -EQ $true) {
            $this.PopulatePage()
        }
        If($this.ZeroPageActive -EQ $true) {
            If($this.MoronPageActive -EQ $true) {
                $this.WriteMoronPage()
            } Else {
                $this.WriteZeroInventoryPage()
            }
        } Else {
            If($this.DivLineDirty -EQ $true) {
                Write-Host "$([InventoryWindow]::DivLineHorizontal.ToAnsiControlSequenceString())"
                $this.DivLineDirty = $false
            }
            If(($this.PlayerChevronVisible -EQ $true) -AND ($this.PlayerChevronDirty -EQ $true)) {
                Foreach($ic in $this.IChevrons) {
                    Write-Host "$($ic.Item1.ToAnsiControlSequenceString())"
                }
                $this.PlayerChevronDirty = $false
            }
            If($this.NumPages -GT 1) {
                If($this.CurrentPage -EQ 1) {
                    If($this.PagingChevronLeftVisible -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronLeftBlank.ToAnsiControlSequenceString())"
                        $this.PagingChevronLeftVisible = $false
                        $this.PagingChevronLeftDirty   = $true
                    }
                    If($this.PagingChevronRightVisible -EQ $false) {
                        $this.PagingChevronRightVisible = $true
                    }
                    If(($this.PagingChevronRightVisible -EQ $true) -AND ($this.PagingChevronRightDirty -EQ $true)) {
                        Write-Host "$([InventoryWindow]::PagingChevronRight.ToAnsiControlSequenceString())"
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
                        Write-Host "$([InventoryWindow]::PagingChevronRight.ToAnsiControlSequenceString())"
                        $this.PagingChevronRightDirty = $false
                    }
                    If(($this.PagingChevronLeftVisible -EQ $true) -AND ($this.PagingChevronLeftDirty -EQ $true)) {
                        Write-Host "$([InventoryWindow]::PagingChevronLeft.ToAnsiControlSequenceString())"
                        $this.PagingChevronLeftDirty = $false
                    }
                } Elseif($this.CurrentPage -GE $this.NumPages) {
                    If($this.PagingChevronRightVisible -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronRightBlank.ToAnsiControlSequenceString())"
                        $this.PagingChevronRightVisible = $false
                        $this.PagingChevronRightDirty   = $true
                    }
                    If($this.PagingChevronLeftVisible -EQ $false) {
                        $this.PagingChevronLeftVisible = $true
                    }
                    If(($this.PagingChevronLeftVisible -EQ $true) -AND ($this.PagingChevronLeftDirty -EQ $true)) {
                        Write-Host "$([InventoryWindow]::PagingChevronLeft.ToAnsiControlSequenceString())"
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
                    Write-Host "$([InventoryWindow]::PagingChevronLeftBlank.ToAnsiControlSequenceString())"
                }
                If($this.PagingChevronRightVisible -EQ $false) {
                    Write-Host "$([InventoryWindow]::PagingChevronRightBlank.ToAnsiControlSequenceString())"
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
                [ATString]$b = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = 15
                            Column = 4
                        }
                    }
                    UserData   = [InventoryWindow]::DescLineBlank
                    UseATReset = $true
                }
                [ATString]$d = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = 15
                            Column = 4
                        }
                    }
                    UserData   = $this.PageRefs[$this.ActiveIChevronIndex].ExamineString
                    UseATReset = $true
                }
                [ATString]$f = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = 16
                            Column = 4
                        }
                    }
                    UserData   = [InventoryWindow]::DescLineBlank
                    UseATReset = $true
                }
                [ATString]$e = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCApplePinkLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = 16
                            Column = 4
                        }
                    }
                    UserData   = $this.PageRefs[$this.ActiveIChevronIndex].PlayerEffectString
                    UseATReset = $true
                }
                [ATString]$h = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = 17
                            Column = 4
                        }
                    }
                    UserData   = [InventoryWindow]::DescLineBlank
                    UseATReset = $true
                }
                [ATString]$i = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleYellowLight24]::new()
                        Decorations     = [ATDecoration]@{
                            Blink  = $true
                            Italic = $true
                        }
                        Coordinates = [ATCoordinates]@{
                            Row    = 17
                            Column = 4
                        }
                    }
                    UserData   = ($this.PageRefs[$this.ActiveIChevronIndex].KeyItem -EQ $true ? 'KEY ITEM' : '')
                    UseATReset = $true
                }
                Write-Host "$($b.ToAnsiControlSequenceString())$($d.ToAnsiControlSequenceString())$($f.ToAnsiControlSequenceString())$($e.ToAnsiControlSequenceString())$($h.ToAnsiControlSequenceString())$($i.ToAnsiControlSequenceString())"
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
                        Row    = 3
                        Column = 15
                    }
                }
                UserData   = [InventoryWindow]::IChevronCharacter
                UseATReset = $true
            },
            $true
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 5
                        Column = 15
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates      = [ATCoordinates]@{
                        Row    = 7
                        Column = 15
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 9
                        Column = 15
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 11
                        Column = 15
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 3
                        Column = 50
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 5
                        Column = 50
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 7
                        Column = 50
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 9
                        Column = 50
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 11
                        Column = 50
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
    }

    [Void]CreateItemLabels() {
        $this.ItemLabels = [List[ATString]]::new()
        [Int]$c          = 0

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
                    UserData = $i.Name
                    UseATReset = $true
                }
            )
            $c++ # FYI - This was intentional
        }
        $this.ResetIChevronPosition()
        $this.CreateItemLabelBlanks()
    }

    [Void]CreateItemLabelBlanks() {
        $this.ItemLabelBlanks = [List[ATString]]::new()
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 3
                        Column = 17
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 5
                        Column = 17
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 7
                        Column = 17
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 9
                        Column = 17
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 11
                        Column = 17
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 3
                        Column = 52
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 5
                        Column = 52
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 7
                        Column = 52
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 9
                        Column = 52
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 11
                        Column = 52
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
    }

    [Void]CalculateNumPages() {
        $pp = $Script:ThePlayer.Inventory.Count / $this.ItemsPerPage
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
        If($Script:ThePlayer.Inventory.Count -LE 0) {
            $this.ZeroPageActive   = $true
            $this.CurrentPageDirty = $false
            $this.ZpPromptDirty    = $true
            $this.ZpBlankedDirty   = $true

            If([InventoryWindow]::MoronCounter -LT 20) {
                [InventoryWindow]::MoronCounter++
            } Else {
                $this.MoronPageActive = $true
            }
        } Else {
            $this.PageRefs        = [List[MapTileObject]]::new()
            $this.ZeroPageActive  = $false
            $this.MoronPageActive = $false
            $rs                   = (($this.CurrentPage * $this.ItemsPerPage) - $this.ItemsPerPage)
            $rs                   = [Math]::Clamp($rs, 0, [Int]::MaxValue)
            $re                   = 10

            Try {
                $this.PageRefs = $Script:ThePlayer.Inventory.GetRange($rs, $re)
            } Catch {
                $this.PageRefs = $Script:ThePlayer.Inventory.GetRange($rs, ($Script:ThePlayer.Inventory.Count - $rs))
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
            Foreach($a in 2..19) {
                [ATString]$b = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $a
                            Column = 2
                        }
                    }
                    UserData   = [InventoryWindow]::ZpLineBlank
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
                        Row    = $this.Height / 2
                        Column = ($this.Width / 2) - ([InventoryWindow]::ZeroPagePrompt.Length / 2)
                    }
                }
                UserData   = [InventoryWindow]::ZeroPagePrompt
                UseATReset = $true
            }
            Write-Host "$($a.ToAnsiControlSequenceString())"
            $this.ZpPromptDirty = $false
        }
    }

    [Void]WriteMoronPage() {}

    [Void]ResetIChevronPosition() {
        $this.IChevrons[$this.ActiveIChevronIndex].Item2          = $false
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData = [InventoryWindow]::IChevronBlankCharacter
        Try {
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Catch {}
        $this.ActiveIChevronIndex                                          = 0
        $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
            Blink = $true
        }
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
        $this.PlayerChevronDirty                                           = $true
        $this.ActiveItemBlinking                                           = $false
        $this.ItemDescDirty                                                = $true
    }

    [Void]HandleInput() {
        $keyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')

        #######################################################################
        #
        # BECAUSE POWERSHELL HAS BEEN REALLY WEIRD ABOUT MAPPING THE VALUE
        # OF VIRTUALKEYCODE TO AN ENUMERATION, TYPED OR OTHERWISE, I SHOULD
        # COMMENT THE MAPPINGS HERE SO THAT IT'S OBVIOUS WHAT KEY IS DOING
        # WHAT.
        #
        #######################################################################
        Switch($keyCap.VirtualKeyCode) {
            27 {
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen
            }

            38 {
                If(($this.ActiveIChevronIndex - 1) -GE 0) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex--
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
            }

            40 {
                If(($this.ActiveIChevronIndex + 1) -LT $this.PageRefs.Count) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex++
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty                                               = $true
                $this.ActiveItemBlinking                                               = $false
                $this.ItemDescDirty                                                    = $true
            }

            39 {
                If(($this.ActiveIChevronIndex + 5) -LT $this.PageRefs.Count) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex += 5
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty                                               = $true
                $this.ActiveItemBlinking                                               = $false
                $this.ItemDescDirty                                                    = $true
            }

            37 {
                If(($this.ActiveIChevronIndex -5) -GE 0) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex -= 5
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty                                               = $true
                $this.ActiveItemBlinking                                               = $false
                $this.ItemDescDirty                                                    = $true
            }

            68 {
                $this.TurnPageForward()
            }

            65 {
                $this.TurnPageBackward()
            }

            83 {
                Switch($this.CurrentPage) {
                    1 {
                        [ItemRemovalStatus]$a = $Script:ThePlayer.RemoveInventoryItemByIndex($this.ActiveIChevronIndex)
                        If($a -EQ [ItemRemovalStatus]::Success) {
                            [Console]::Beep(493.9, 250)
                            [Console]::Beep((493.9 * 2), 250)
                            $this.BookDirty        = $true
                            $this.CurrentPageDirty = $true

                            Return
                        }
                        [Console]::Beep(493.9, 250)
                        [Console]::Beep((493.9 / 2), 250)
                    }

                    { $_ -GT 1 } {
                        [Int]$a               = ((10 * ($this.CurrentPage - 1)) + $this.ActiveIChevronIndex)
                        [ItemRemovalStatus]$b = $Script:ThePlayer.RemoveInventoryItemByIndex($a)
                        If($b -EQ [ItemRemovalStatus]::Success) {
                            [Console]::Beep(493.9, 250)
                            [Console]::Beep((493.9 * 2), 250)
                            $this.BookDirty        = $true
                            $this.CurrentPageDirty = $true

                            Return
                        }
                        [Console]::Beep(493.9, 250)
                        [Console]::Beep((493.9 / 2), 250)
                    }
                }
            }
        }
    }
}
