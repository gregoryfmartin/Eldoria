using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# STATUS ITEM INVENTORY WINDOW
#
# DISPLAYS THE PLAYER'S CURRENT ITEM INVENTORY IN A VERTICAL PAGING FORMAT.
#
###############################################################################

Class StatusItemInventoryWindow : WindowBase {
    Static [Int]$WindowLTRow    = 5
    Static [Int]$WindowLTColumn = 13
    Static [Int]$WindowRBRow    = 22
    Static [Int]$WindowRBColumn = 68
    
    Static [String]$WindowTitle                = 'Items'
    Static [String]$IChevronCharacter          = '❱'
    Static [String]$IChevronBlankCharacter     = ' '
    Static [String]$PagingChevronUpCharacter   = "`u{2B61}"
    Static [String]$PagingChevronDownCharacter = "`u{2B63}"
    Static [String]$PagingChevronBlankCharater = ' '
    Static [String]$ItemLabelBlank             = ' ' * (([StatusItemInventoryWindow]::WindowRBColumn - [StatusItemInventoryWindow]::WindowLTColumn) - 4)
    Static [String]$ZpLineBlank                = ' ' * (([StatusItemInventoryWindow]::WindowRBColumn - [StatusItemInventoryWindow]::WindowLTColumn) - 1)
    Static [String]$ZeroPagePrompt             = 'You have no items in your inventory.'

    [Boolean]$DebugMode
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

    [Int]$MoronCounter
    [Int]$ItemsPerPage
    [Int]$NumPages
    [Int]$CurrentPage
    [Int]$ActiveIChevronIndex

    [List[ValueTuple[[MapTileObject], [Int]]]]$PageRefs
    [List[ValueTuple[[ATString], [Boolean]]]]$IChevrons
    [List[ATString]]$ItemLabels
    [List[ATString]]$ItemLabelBlanks

    [ATString]$PagingChevronUp
    [ATString]$PagingChevronDown
    [ATString]$PagingChevronUpBlank
    [ATString]$PagingChevronDownBlank

    StatusItemInventoryWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [StatusItemInventoryWindow]::WindowLTRow
            Column = [StatusItemInventoryWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [StatusItemInventoryWindow]::WindowRBRow
            Column = [StatusItemInventoryWindow]::WindowRBColumn
        }

        $this.UpdateDimensions()
        $this.SetupTitle([StatusItemInventoryWindow]::WindowTitle, [CCTextDefault24]::new())

        $this.DebugMode                = $false
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
        $this.MoronCounter             = 0
        $this.ItemsPerPage             = 11
        $this.NumPages                 = 1
        $this.CurrentPage              = 1
        $this.ActiveIChevronIndex      = 0
        $this.PageRefs                 = [List[ValueTuple[[MapTileObject], [Int]]]]::new()
        $this.IChevrons                = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        $this.ItemLabels               = [List[ATString]]::new()
        $this.ItemLabelBlanks          = [List[ATString]]::new()

        $this.PagingChevronUp        = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCAppleVYellowLight24]::new()
                Coordinates     = [ATCoordinates]@{
                    Row    = $this.LeftTop.Row + 1
                    Column = $this.RightBottom.Column - 2
                }
            }
            UserData   = "$([StatusItemInventoryWindow]::PagingChevronUpCharacter)"
            UseATReset = $true
        }
        $this.PagingChevronDown      = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCAppleVYellowLight24]::new()
                Coordinates     = [ATCoordinates]@{
                    Row    = $this.RightBottom.Row - 1
                    Column = $this.RightBottom.Column - 2
                }
            }
            UserData   = "$([StatusItemInventoryWindow]::PagingChevronDownCharacter)"
            UseATReset = $true
        }
        $this.PagingChevronUpBlank   = [ATString]@{
            Prefix = [ATStringPrefix]@{
                Coordinates = [ATCoordinates]@{
                    Row    = $this.PagingChevronUp.Prefix.Coordinates.Row
                    Column = $this.PagingChevronUp.Prefix.Coordinates.Column
                }
            }
            UserData   = "$([StatusItemInventoryWindow]::PagingChevronBlankCharater)"
            UseATReset = $true
        }
        $this.PagingChevronDownBlank = [ATString]@{
            Prefix = [ATStringPrefix]@{
                Coordinates = [ATCoordinates]@{
                    Row    = $this.PagingChevronDown.Prefix.Coordinates.Row
                    Column = $this.PagingChevronDown.Prefix.Coordinates.Column
                }
            }
            UserData   = "$([StatusItemInventoryWindow]::PagingChevronBlankCharater)"
            UseATReset = $true
        }

        $this.CreateIChevrons()
    }

    [Void]CreateIChevrons() {
        $this.IChevrons = [List[ValueTuple[[ATString], [Boolean]]]]::new()

        For([Int]$I = 0; $I -LT $this.ItemsPerPage; $I++) {
            $this.IChevrons.Add([ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = ($this.LeftTop.Row + 1) + $I
                            Column = $this.LeftTop.Column + 1
                        }
                    }
                    UserData   = If($I -EQ 0) { [StatusItemInventoryWindow]::IChevronCharacter } Else { [StatusItemInventoryWindow]::IChevronBlankCharacter }
                    UseATReset = $true
                },
                $I -EQ 0
            ))
        }
    }

    [Void]CreateItemLabels() {
        $this.ItemLabels = [List[ATString]]::new()
        
        For([Int]$I = 0; $I -LT $this.PageRefs.Count; $I++) {
            $this.ItemLabels.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.IChevrons[$I].Item1.Prefix.Coordinates.Row
                            Column = $this.IChevrons[$I].Item1.Prefix.Coordinates.Column + 2
                        }
                    }
                    UserData   = "$($this.PageRefs[$I].Item1.Name)$([ATControlSequences]::GenerateCoordinateString($this.IChevrons[$I].Item1.Prefix.Coordinates.Row, $this.RightBottom.Column - 6))$($this.PageRefs[$I].Item2)"
                    UseATReset = $true
                }
            )
        }
        
        $this.ResetIChevronPosition()
        $this.CreateItemLabelBlanks()
    }

    [Void]CreateItemLabelBlanks() {
        $this.ItemLabelBlanks = [List[ATString]]::new()

        For([Int]$I = 0; $I -LT $this.ItemsPerPage; $I++) {
            $this.ItemLabelBlanks.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        Coordinates = [ATCoordinates]@{
                            Row    = ($this.LeftTop.Row + 1) + $I
                            Column = $this.LeftTop.Column + 2
                        }
                    }
                    UserData   = [StatusItemInventoryWindow]::ItemLabelBlank
                    UseATReset = $true
                }
            )
        }
    }
    
    [Void]CalculateNumPages() {
        $PP = $Script:ThePlayer.ItemInventory.Count / $this.ItemsPerPage
        If($PP -LT 1) {
            $this.NumPages = 1
        } Else {
            $this.NumPages = [Math]::Ceiling($PP)
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
        If($Script:ThePlayer.ItemInventory.Count -LE 0) {
            $this.ZeroPageActive   = $true
            $this.CurrentPageDirty = $false
            $this.ZpPromptDirty    = $true
            $this.ZpBlankedDirty   = $true
            
            If($this.MoronCounter -LT 20) {
                $this.MoronCounter++
            } Else {
                $this.MoronPageActive = $true
            }
        } Else {
            $this.PageRefs        = [List[ValueTuple[[MapTileObject], [Int]]]]::new()
            $this.ZeroPageActive  = $false
            $this.MoronPageActive = $false
            $RS                   = (($this.CurrentPage * $this.ItemsPerPage) - $this.ItemsPerPage)
            $RS                   = [Math]::Clamp($RS, 0, [Int]::MaxValue)
            $RE                   = $this.ItemsPerPage

            Try {
                $this.PageRefs = $Script:ThePlayer.ItemInventory.GetRange($RS, $RE)
            } Catch {
                $this.PageRefs = $Script:ThePlayer.ItemInventory.GetRange($RS, ($Script:ThePlayer.ItemInventory.Count - $RS))
            }

            $this.CreateItemLabels()
            $this.ItemsListDirty   = $true
            $this.CurrentPageDirty = $false
        }
    }
    
    [Void]WriteItemLabels() {
        Foreach($I in $this.ItemLabelBlanks) {
            Write-Host "$($I.ToAnsiControlSequenceString())"
        }
        Foreach($I in $this.ItemLabels) {
            Write-Host "$($I.ToAnsiControlSequenceString())"
        }
    }
    
    [Void]WriteZeroInventoryPage() {
        If($this.ZpBlankedDirty -EQ $true) {
            Foreach($A in 1..($this.Height - 1)) {
                [ATString]$B = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row + $A
                            Column = $this.LeftTop.Column + 1
                        }
                    }
                    UserData   = "$([StatusItemInventoryWindow]::ZpLineBlank)"
                    UseATReset = $true
                }
                Write-Host "$($B.ToAnsiControlSequenceString())"
            }
            $this.ZpBlankedDirty = $false
        }
        If($this.ZpPromptDirty -EQ $true) {
            [ATString]$A = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + ($this.Height / 2)
                        Column = $this.LeftTop.Column + (($this.Width / 2) - ([StatusItemInventoryWindow]::ZeroPagePrompt.Length / 2))
                    }
                }
                UserData   = "$([StatusItemInventoryWindow]::ZeroPagePrompt)"
                UseATReset = $true
            }
            Write-Host "$($A.ToAnsiControlSequenceString())"
            $this.ZpPromptDirty = $false
        }
    }
    
    [Void]WriteMoronPage() {}
    
    [Void]ResetIChevronPosition() {
        $this.IChevrons[$this.ActiveIChevronIndex].Item2          = $false
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData = [StatusItemInventoryWindow]::IChevronBlankCharacter
        Try {
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Catch {}
        $this.ActiveIChevronIndex                                      = 0
        $this.IChevrons[$this.ActiveIChevronIndex].Item2               = $true
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData      = [StatusItemInventoryWindow]::IChevronCharacter
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations = [ATDecoration]@{
            Blink = $true
        }
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
        $this.PlayerChevronDirty                                           = $true
        $this.ActiveItemBlinking                                           = $false
        $this.ItemDescDirty                                                = $true
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
            If(($this.PlayerChevronVisible -EQ $true) -AND ($this.PlayerChevronDirty -EQ $true)) {
                Foreach($IC in $this.IChevrons) {
                    Write-Host "$($IC.Item1.ToAnsiControlSequenceString())"
                }
                $this.PlayerChevronDirty = $false
            }
            If($this.NumPages -GT 1) {
                If($this.CurrentPage -EQ 1) {
                    If($this.PagingChevronUpVisible -EQ $true) {
                        Write-Host "$($this.PagingChevronUpBlank.ToAnsiControlSequenceString())"
                        $this.PagingChevronUpVisible = $false
                        $this.PagingChevronUpDirty   = $true
                    }
                    If($this.PagingChevronDownVisible -EQ $false) {
                        $this.PagingChevronDownVisible = $true
                    }
                    If(($this.PagingChevronDownVisible -EQ $true) -AND ($this.PagingChevronDownDirty -EQ $true)) {
                        Write-Host "$($this.PagingChevronDown.ToAnsiControlSequenceString())"
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
                        Write-Host "$($this.PagingChevronDown.ToAnsiControlSequenceString())"
                        $this.PagingChevronDownDirty = $false
                    }
                    If(($this.PagingChevronUpVisible -EQ $true) -AND ($this.PagingChevronUpDirty -EQ $true)) {
                        Write-Host "$($this.PagingChevronUp.ToAnsiControlSequenceString())"
                        $this.PagingChevronUpDirty = $false
                    }
                } Elseif($this.CurrentPage -GE $this.NumPages) {
                    If($this.PagingChevronDownVisible -EQ $true) {
                        Write-Host "$($this.PagingChevronDownBlank.ToAnsiControlSequenceString())"
                        $this.PagingChevronDownVisible = $false
                        $this.PagingChevronDownDirty   = $true
                    }
                    If($this.PagingChevronUpVisible -EQ $false) {
                        $this.PagingChevronUpVisible = $true
                    }
                    If(($this.PagingChevronUpVisible -EQ $true) -AND ($this.PagingChevronUpDirty -EQ $true)) {
                        Write-Host "$($this.PagingChevronUp.ToAnsiControlSequenceString())"
                        $this.PagingChevronUpDirty = $false
                    }
                }
            }
            If($this.ActiveItemBlinking -EQ $false) {
                $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations = [ATDecoration]@{
                    Blink = $true
                }
                $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCListItemCurrentHighlight24]::new()

                $this.ItemsListDirty     = $true
                $this.ActiveItemBlinking = $true
            }
            If($this.ItemsListDirty -EQ $true) {
                $this.WriteItemLabels()
                Write-Host "$([ATControlSequences]::CursorHide)"
                $this.ItemsListDirty = $false
            }
            
        }
    }
    
    [Void]HandleInput() {
        $KeyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')

        Switch($KeyCap.VirtualKeyCode) {
            27 {  # ESCAPE
                # THIS LOGIC NEEDS TO CHANGE TO GIVE INPUT BACK TO THE MAIN MENU
                <#
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen
                #>
                
                $Script:TheStatusScreenState = [StatusScreenState]::MainMenu
                
                Break
            }

            38 {  # UP ARROW
                If($this.ZeroPageActive -EQ $true) {
                    Return
                }
                
                If(($this.ActiveIChevronIndex - 1) -GE 0) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [StatusItemInventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex--
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [StatusItemInventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true

                # UPDATE THE INFORMATION IN THE HEADER WINDOW WITH THE CURRENT ITEM
                $Script:TheStatusItemHeaderWindow.UpdateItemDesc($this.PageRefs[$this.ActiveIChevronIndex].Item1.ExamineString)
                $Script:TheStatusItemHeaderWindow.UpdateItemEffect($this.PageRefs[$this.ActiveIChevronIndex].Item1.PlayerEffectString)
            }

            40 {  # DOWN ARROW
                If($this.ZeroPageActive -EQ $true) {
                    Return
                }
                
                If(($this.ActiveIChevronIndex + 1) -LT $this.PageRefs.Count) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [StatusItemInventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex++
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [StatusItemInventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true

                # UPDATE THE INFORMATION IN THE HEADER WINDOW WITH THE CURRENT ITEM
                $Script:TheStatusItemHeaderWindow.UpdateItemDesc($this.PageRefs[$this.ActiveIChevronIndex].Item1.ExamineString)
                $Script:TheStatusItemHeaderWindow.UpdateItemEffect($this.PageRefs[$this.ActiveIChevronIndex].Item1.PlayerEffectString)
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

            <#
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
            #>
        }    
    }
}
