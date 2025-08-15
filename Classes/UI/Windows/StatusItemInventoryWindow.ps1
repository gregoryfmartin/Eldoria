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
    Static [Int]$WindowLTRow    = 7
    Static [Int]$WindowLTColumn = 13
    Static [Int]$WindowRBRow    = 22
    Static [Int]$WindowRBColumn = 68
    
    Static [String]$WindowTitle                = 'Items'
    Static [String]$IChevronCharacter          = '❱'
    Static [String]$IChevronBlankCharacter     = ' '
    Static [String]$PagingChevronUpCharacter   = "`u{2B61}"
    Static [String]$PagingChevronDownCharacter = "`u{2B63}"
    Static [String]$PagingChevronBlankCharater = ' '
    Static [String]$ItemLabelBlank             = ' ' * ([StatusItemInventoryWindow]::WindowRBColumn - [StatusItemInventoryWindow]::WindowLTColumn)

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

    [String]$ZeroPagePrompt

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
        $this.ItemsPerPage             = 10
        $this.NumPages                 = 1
        $this.CurrentPage              = 1
        $this.ActiveIChevronIndex      = 0
        $this.ZeroPagePrompt           = 'You have no items in your inventory.'
        $this.PageRefs                 = [List[ValueTuple[[MapTileObject], [Int]]]]::new()
        $this.IChevrons                = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        $this.ItemLabels               = [List[ATString]]::new()
        $this.ItemLabelBlanks          = [List[ATString]]::new()
        $this.PagingChevronUp          = $null
        $this.PagingChevronDown        = $null
        $this.PagingChevronUpBlank     = $null
        $this.PagingChevronDownBlank   = $null

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
                            Row    = $this.LeftTop.Row + $I
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
                            Row    = $this.LeftTop.Row + $I
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
            $this.CurrentPageDirty = $true
            $this.ActiveItemBlinking = $false
            $this.ItemDescDirty = $true
        }
    }
    
    [Void]TurnPageUp() {
        If(($this.CurrentPage - 1) -GE 1) {
            $this.CurrentPage--
            $this.CurrentPageDirty = $true
            $this.ActiveItemBlinking = $false
            $this.ItemDescDirty = $true
        }
    }
    
    [Void]PopulatePage() {
        If($Script:ThePlayer.ItemInventory.Count -LE 0) {
            $this.ZeroPageActive   = $true
            $this.CurrentPageDirty = $false
            $this.ZpPromptDirty    = $true
            $this.ZpBlankedDirty   = $true
            
            If([StatusItemInventoryWindow]::MoronCounter -LT 20) {
                [StatusItemInventoryWindow]::MoronCounter++
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

    [Void]Draw() {
        ([WindowBase]$this).Draw()
    }
}
