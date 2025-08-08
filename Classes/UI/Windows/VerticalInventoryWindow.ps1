using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# VERTICAL INVENTORY WINDOW
#
# THIS CLASS IS A VARIANT OF THE INVENTORY WINDOW THAT DISPLAYS ITEMS IN A
# SINGLE VERTICAL COLUMN WITH VERTICAL PAGING CONTROLS.
#
###############################################################################

Class VerticalInventoryWindow : WindowBase {
    Static [Int]$WindowLTRow    = 1
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowBRRow    = 20
    Static [Int]$WindowBRColumn = 79

    Static [String]$WindowTitle = 'Inventory'

    Static [String]$IChevronCharacter          = '❱'
    Static [String]$IChevronBlankCharacter     = ' '
    Static [String]$PagingChevronUpCharacter   = "`u{2B61}"  # ⭡
    Static [String]$PagingChevronDownCharacter = "`u{2B63}"  # ⭣
    Static [String]$PagingChevronBlankCharater = ' '

    Static [String]$DivLineHorizontalString = '─────────────────────────────────────────────────────────────────────────────'
    Static [String]$ZpLineBlank             = '                                                                             '
    Static [String]$DescLineBlank           = '                                                                          '
    Static [String]$ItemLabelBlank          = '                                   '

    Static [ATString]$PagingChevronUp = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCAppleYellowLight24]::new()
            Coordinates     = [ATCoordinates]@{
                Row    = 2
                Column = 40  # Center of window width
            }
        }
        UserData   = "$([VerticalInventoryWindow]::PagingChevronUpCharacter)"
        UseATReset = $true
    }
    Static [ATString]$PagingChevronDown = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCAppleYellowLight24]::new()
            Coordinates     = [ATCoordinates]@{
                Row    = 18  # Near bottom of window
                Column = 40  # Center of window width
            }
        }
        UserData   = "$([VerticalInventoryWindow]::PagingChevronDownCharacter)"
        UseATReset = $true
    }
    Static [ATString]$PagingChevronUpBlank = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCAppleMintLight24]::new()
            Coordinates     = [ATCoordinates]@{
                Row    = 2
                Column = 40
            }
        }
        UserData   = "$([VerticalInventoryWindow]::PagingChevronBlankCharater)"
        UseATReset = $true
    }
    Static [ATString]$PagingChevronDownBlank = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCAppleMintLight24]::new()
            Coordinates     = [ATCoordinates]@{
                Row    = 18
                Column = 40
            }
        }
        UserData   = "$([VerticalInventoryWindow]::PagingChevronBlankCharater)"
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
        UserData   = "$([VerticalInventoryWindow]::DivLineHorizontalString)"
        UseATReset = $true
    }

    Static [Boolean]$DebugMode     = $false
    Static [Int]$MoronCounter      = 0
    Static [String]$ZeroPagePrompt = 'You have no items in your inventory.'

    [Boolean]$PlayerChevronDirty
    [Boolean]$PagingChevronUpDirty
    [Boolean]$PagingChevronDownDirty
    [Boolean]$ItemsListDirty
    [Boolean]$CurrentPageDirty
    [Boolean]$PlayerChevronVisible
    [Boolean]$PagingChevronUpVisible
    [Boolean]$PagingChevronDownVisible
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

    VerticalInventoryWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [VerticalInventoryWindow]::WindowLTRow
            Column = [VerticalInventoryWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [VerticalInventoryWindow]::WindowBRRow
            Column = [VerticalInventoryWindow]::WindowBRColumn
        }

        $this.UpdateDimensions()
        $this.SetupTitle([VerticalInventoryWindow]::WindowTitle, [CCTextDefault24]::new())

        $this.PlayerChevronDirty       = $true
        $this.PagingChevronUpDirty     = $true
        $this.PagingChevronDownDirty   = $true
        $this.ItemsListDirty           = $true
        $this.CurrentPageDirty         = $true
        $this.PlayerChevronVisible     = $true
        $this.PagingChevronUpVisible   = $false
        $this.PagingChevronDownVisible = $false
        $this.ZeroPageActive           = $false
        $this.MoronPageActive          = $false
        $this.BookDirty                = $true
        $this.ActiveItemBlinking       = $false
        $this.DivLineDirty             = $true
        $this.ItemDescDirty            = $true
        $this.ZpBlankedDirty           = $true
        $this.ZpPromptDirty            = $true
        $this.ItemsPerPage             = 15  # More items per page since we're vertical
        $this.NumPages                 = 1
        $this.CurrentPage              = 1
        $this.PageRefs                 = [List[MapTileObject]]::new()

        $this.CreateIChevrons()
    }

    [Void]CreateIChevrons() {
        $this.IChevrons = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        
        # Create 15 chevrons in a single column
        for ($i = 0; $i -lt 15; $i++) {
            $this.IChevrons.Add([ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = 3 + $i
                            Column = 2
                        }
                    }
                    UserData   = If ($i -eq 0) { [VerticalInventoryWindow]::IChevronCharacter } Else { [VerticalInventoryWindow]::IChevronBlankCharacter }
                    UseATReset = $true
                },
                $i -eq 0
            ))
        }
    }

    [Void]CreateItemLabels() {
        $this.ItemLabels = [List[ATString]]::new()
        
        for ($i = 0; $i -lt $this.PageRefs.Count; $i++) {
            $this.ItemLabels.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.IChevrons[$i].Item1.Prefix.Coordinates.Row
                            Column = $this.IChevrons[$i].Item1.Prefix.Coordinates.Column + 2
                        }
                    }
                    UserData   = $this.PageRefs[$i].Name
                    UseATReset = $true
                }
            )
        }
        
        $this.ResetIChevronPosition()
        $this.CreateItemLabelBlanks()
    }

    [Void]CreateItemLabelBlanks() {
        $this.ItemLabelBlanks = [List[ATString]]::new()
        
        # Create blanks for all 15 possible item slots
        for ($i = 0; $i -lt 15; $i++) {
            $this.ItemLabelBlanks.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        Coordinates = [ATCoordinates]@{
                            Row    = 3 + $i
                            Column = 4
                        }
                    }
                    UserData   = [VerticalInventoryWindow]::ItemLabelBlank
                    UseATReset = $true
                }
            )
        }
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
                Write-Host "$([VerticalInventoryWindow]::DivLineHorizontal.ToAnsiControlSequenceString())"
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
                    If($this.PagingChevronUpVisible -EQ $true) {
                        Write-Host "$([VerticalInventoryWindow]::PagingChevronUpBlank.ToAnsiControlSequenceString())"
                        $this.PagingChevronUpVisible = $false
                        $this.PagingChevronUpDirty   = $true
                    }
                    If($this.PagingChevronDownVisible -EQ $false) {
                        $this.PagingChevronDownVisible = $true
                    }
                    If(($this.PagingChevronDownVisible -EQ $true) -AND ($this.PagingChevronDownDirty -EQ $true)) {
                        Write-Host "$([VerticalInventoryWindow]::PagingChevronDown.ToAnsiControlSequenceString())"
                        $this.PagingChevronDownDirty = $false
                    }
                } Elseif(($this.CurrentPage -GT 1) -AND ($this.CurrentPage -LT $this.NumPages)) {
                    If($this.PagingChevronUpVisible -EQ $false) {
                        $this.PagingChevronUpVisible = $true
                    }
                    If($this.PagingChevronDownVisible -EQ $false) {
                        $this.PagingChevronDownVisible = $true
                    }
                    If(($this.PagingChevronDownVisible -EQ $true) -AND ($this.PagingChevronDownDirty -EQ $true)) {
                        Write-Host "$([VerticalInventoryWindow]::PagingChevronDown.ToAnsiControlSequenceString())"
                        $this.PagingChevronDownDirty = $false
                    }
                    If(($this.PagingChevronUpVisible -EQ $true) -AND ($this.PagingChevronUpDirty -EQ $true)) {
                        Write-Host "$([VerticalInventoryWindow]::PagingChevronUp.ToAnsiControlSequenceString())"
                        $this.PagingChevronUpDirty = $false
                    }
                } Elseif($this.CurrentPage -GE $this.NumPages) {
                    If($this.PagingChevronDownVisible -EQ $true) {
                        Write-Host "$([VerticalInventoryWindow]::PagingChevronDownBlank.ToAnsiControlSequenceString())"
                        $this.PagingChevronDownVisible = $false
                        $this.PagingChevronDownDirty   = $true
                    }
                    If($this.PagingChevronUpVisible -EQ $false) {
                        $this.PagingChevronUpVisible = $true
                    }
                    If(($this.PagingChevronUpVisible -EQ $true) -AND ($this.PagingChevronUpDirty -EQ $true)) {
                        Write-Host "$([VerticalInventoryWindow]::PagingChevronUp.ToAnsiControlSequenceString())"
                        $this.PagingChevronUpDirty = $false
                    }
                }
            }
            If($this.ItemsListDirty -EQ $true) {
                $this.WriteItemLabels()
                Write-Host "$([ATControlSequences]::CursorHide)"
                $this.ItemsListDirty = $false
            }
            If($this.ItemDescDirty -EQ $true) {
                [ATString]$descBlank = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = 15
                            Column = 4
                        }
                    }
                    UserData   = [VerticalInventoryWindow]::DescLineBlank
                    UseATReset = $true
                }
                [ATString]$desc = [ATString]@{
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
                [ATString]$effectBlank = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = 16
                            Column = 4
                        }
                    }
                    UserData   = [VerticalInventoryWindow]::DescLineBlank
                    UseATReset = $true
                }
                [ATString]$effect = [ATString]@{
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
                [ATString]$keyItemBlank = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = 17
                            Column = 4
                        }
                    }
                    UserData   = [VerticalInventoryWindow]::DescLineBlank
                    UseATReset = $true
                }
                [ATString]$keyItem = [ATString]@{
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
                Write-Host "$($descBlank.ToAnsiControlSequenceString())$($desc.ToAnsiControlSequenceString())$($effectBlank.ToAnsiControlSequenceString())$($effect.ToAnsiControlSequenceString())$($keyItemBlank.ToAnsiControlSequenceString())$($keyItem.ToAnsiControlSequenceString())"
                $this.ItemDescDirty = $false
            }
        }
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

    [Void]TurnPageDown() {
        If(($this.CurrentPage + 1) -LE $this.NumPages) {
            $this.CurrentPage++
            $this.CurrentPageDirty   = $true
            $this.ActiveItemBlinking = $false
            $this.ItemDescDirty      = $true
        }
    }

    [Void]TurnPageUp() {
        If(($this.CurrentPage - 1) -GE 1) {
            $this.CurrentPage--
            $this.CurrentPageDirty   = $true
            $this.ActiveItemBlinking = $false
            $this.ItemDescDirty      = $true
        }
    }

    [Void]PopulatePage() {
        If($Script:ThePlayer.Inventory.Count -LE 0) {
            $this.ZeroPageActive    = $true
            $this.CurrentPageDirty  = $false
            $this.ZpPromptDirty     = $true
            $this.ZpBlankedDirty    = $true

            If([VerticalInventoryWindow]::MoronCounter -LT 20) {
                [VerticalInventoryWindow]::MoronCounter++
            } Else {
                $this.MoronPageActive = $true
            }
        } Else {
            $this.PageRefs        = [List[MapTileObject]]::new()
            $this.ZeroPageActive  = $false
            $this.MoronPageActive = $false
            $rs                   = (($this.CurrentPage * $this.ItemsPerPage) - $this.ItemsPerPage)
            $rs                   = [Math]::Clamp($rs, 0, [Int]::MaxValue)
            $re                   = $this.ItemsPerPage

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
                    UserData   = [VerticalInventoryWindow]::ZpLineBlank
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
                        Column = ($this.Width / 2) - ([VerticalInventoryWindow]::ZeroPagePrompt.Length / 2)
                    }
                }
                UserData   = [VerticalInventoryWindow]::ZeroPagePrompt
                UseATReset = $true
            }
            Write-Host "$($a.ToAnsiControlSequenceString())"
            $this.ZpPromptDirty = $false
        }
    }

    [Void]WriteMoronPage() {}

    [Void]ResetIChevronPosition() {
        $this.IChevrons[$this.ActiveIChevronIndex].Item2          = $false
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData = [VerticalInventoryWindow]::IChevronBlankCharacter
        Try {
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Catch {}
        $this.ActiveIChevronIndex                                      = 0
        $this.IChevrons [$this.ActiveIChevronIndex].Item2              = $true
        $this.IChevrons [$this.ActiveIChevronIndex].Item1.UserData     = [VerticalInventoryWindow]::IChevronCharacter
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
            27 {  # ESCAPE
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen
            }

            38 {  # UP ARROW
                If($this.ZeroPageActive -EQ $true) {
                    Return
                }
                
                If(($this.ActiveIChevronIndex - 1) -GE 0) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [VerticalInventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex--
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [VerticalInventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
            }

            40 {  # DOWN ARROW
                If($this.ZeroPageActive -EQ $true) {
                    Return
                }
                
                If(($this.ActiveIChevronIndex + 1) -LT $this.PageRefs.Count) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [VerticalInventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex++
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [VerticalInventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
            }

            33 {  # PAGE UP
                If($this.ZeroPageActive -EQ $true) {
                    Return
                }
                
                $this.TurnPageUp()
            }

            34 {  # PAGE DOWN
                If($this.ZeroPageActive -EQ $true) {
                    Return
                }
                
                $this.TurnPageDown()
            }

            83 {  # S
                If($this.ZeroPageActive -EQ $true) {
                    Return
                }
                
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
                        [Int]$a               = (($this.ItemsPerPage * ($this.CurrentPage - 1)) + $this.ActiveIChevronIndex)
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
