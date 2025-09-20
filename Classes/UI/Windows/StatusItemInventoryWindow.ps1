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
    Static [Int]$WindowRBRow    = 17
    Static [Int]$WindowRBColumn = 68
    
    Static [String]$WindowTitle                = 'Items'
    Static [String]$PagingChevronUpCharacter   = "`u{2B61}"
    Static [String]$PagingChevronDownCharacter = "`u{2B63}"
    Static [String]$PagingChevronBlankCharater = ' '
    Static [String]$ZpLineBlank                = ' ' * (([StatusItemInventoryWindow]::WindowRBColumn - [StatusItemInventoryWindow]::WindowLTColumn) - 1)
    Static [String]$ZeroPagePrompt             = 'You have no items in your inventory.'

    [Boolean]$PagingChevronUpDirty
    [Boolean]$PagingChevronDownDirty
    [Boolean]$ItemsListDirty
    [Boolean]$CurrentPageDirty
    [Boolean]$PagingChevronUpVisible
    [Boolean]$PagingChevronDownVisible
    [Boolean]$ZeroPageActive
    [Boolean]$MoronPageActive
    [Boolean]$BookDirty
    [Boolean]$ItemDescDirty
    [Boolean]$ZpBlankedDirty
    [Boolean]$ZpPromptDirty

    [Int]$MoronCounter
    [Int]$ItemsPerPage
    [Int]$NumPages
    [Int]$CurrentPage

    [List[ValueTuple[[MapTileObject], [Int]]]]$PageRefs

    [ATString]$PagingChevronUp
    [ATString]$PagingChevronDown
    [ATString]$PagingChevronUpBlank
    [ATString]$PagingChevronDownBlank
    
    [UIEMenu]$Listing

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

        $this.PagingChevronUpDirty     = $true
        $this.PagingChevronDownDirty   = $true
        $this.ItemsListDirty           = $true
        $this.CurrentPageDirty         = $true
        $this.PagingChevronUpVisible   = $false
        $this.PagingChevronDownVisible = $false
        $this.ZeroPageActive           = $false
        $this.MoronPageActive          = $false
        $this.BookDirty                = $true
        $this.ItemDescDirty            = $true
        $this.ZpBlankedDirty           = $true
        $this.ZpPromptDirty            = $true
        $this.MoronCounter             = 0
        $this.ItemsPerPage             = 11
        $this.NumPages                 = 1
        $this.CurrentPage              = 1
        $this.PageRefs                 = [List[ValueTuple[[MapTileObject], [Int]]]]::new()
        $this.Listing                  = [UIEMenu]::new()

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
    }

    [Void]UpdateListingContents() {
        If($null -NE $this.PageRefs) {
            [List[Hashtable]]$Temp = [List[Hashtable]]::new()
            
            For([Int]$A = 0; $A -LT $this.PageRefs.Count; $A++) {
                $Temp.Add(@{
                    Label = "$($this.PageRefs[$A].Item1.Name)$([ATControlSequences]::GenerateCoordinateString($this.LeftTop.Row + 1 + $A, $this.RightBottom.Column - 6))$($this.PageRefs[$A].Item2)"
                    Action = {}
                })
            }
            
            $this.Listing.InitializeMenuItems(
                $Temp.ToArray(),
                $this.LeftTop
            )
            $this.Listing.ResetActiveIndex()
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
            # $this.ActiveItemBlinking = $false
            $this.ItemDescDirty      = $true
        }
    }
    
    [Void]TurnPageUp() {
        If(($this.CurrentPage - 1) -GE 1) {
            $this.CurrentPage--
            $this.CurrentPageDirty   = $true
            # $this.ActiveItemBlinking = $false
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

            $this.UpdateListingContents()
            $this.ItemsListDirty   = $true
            $this.CurrentPageDirty = $false
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
            } Elseif($this.NumPages -EQ 1) {
                If($this.PagingChevronUpVisible -EQ $true) {
                    $this.PagingChevronUpVisible = $false
                    Write-Host "$($this.PagingChevronUpBlank.ToAnsiControlSequenceString())"
                }
                If($this.PagingChevronDownVisible -EQ $true) {
                    $this.PagingChevronDownVisible = $false
                    Write-Host "$($this.PagingChevronDownBlank.ToAnsiControlSequenceString())"
                }
            }
            If($this.ItemsListDirty -EQ $true) {
                $Script:TheBufferManager.ClearArea(
                    $this.LeftTop,
                    $this.RightBottom,
                    3
                )

                $Script:TheStatusItemHeaderWindow.UpdateAllData(
                    $this.PageRefs[$this.Listing.ActiveIndex].Item1.ExamineString,
                    $this.PageRefs[$this.Listing.ActiveIndex].Item1.PlayerEffectString
                )
                
                $this.ItemsListDirty = $false
            }
            
            $this.Listing.Draw()
        }
    }

    [Void]SetListDirty() {
        $this.ItemsListDirty = $true
        $this.Listing.SetAllDirty()
    }
    
    [Void]HandleInput() {
        $KeyCap = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')

        Switch($KeyCap.VirtualKeyCode) {
            13 { # ENTER
                If($this.ZeroPageActive -EQ $true) {
                    Return
                }
                
                # INVOKEITEMACTION ISN'T USED HERE BECAUSE THE ITEMS DON'T DO ANYTHING AT THIS POINT
                # ALTHOUGH IT DOES RAISE SOME PRETTY SERIOUS FUNCTIONALITY QUESTIONS...
                # 
                # HMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
                
                $Script:TheItemToDrop = $this.PageRefs[$this.Listing.ActiveIndex].Item1
                
                # THIS RAISES A SUPER SERIOUS QUESTION!!!
                # $Script:TheBufferManager.CopyActiveToBufferB()
                
                $Script:TheStatusScreenState = [StatusScreenState]::ItemDropConfirm

                Break
            }

            27 {  # ESCAPE
                $Script:TheStatusScreenState = [StatusScreenState]::MainMenu
                
                Break
            }

            38 {  # UP ARROW
                If($this.ZeroPageActive -EQ $true) {
                    Return
                }
                
                $this.Listing.MoveActiveIndexUp()
                $this.Listing.PlayMoveSound()
                
                $Script:TheStatusItemHeaderWindow.UpdateAllData(
                    $this.PageRefs[$this.Listing.ActiveIndex].Item1.ExamineString,
                    $this.PageRefs[$this.Listing.ActiveIndex].Item1.PlayerEffectString
                )
            
                Break
            }

            40 {  # DOWN ARROW
                If($this.ZeroPageActive -EQ $true) {
                    Return
                }
                
                $this.Listing.MoveActiveIndexDown()
                $this.Listing.PlayMoveSound()
                
                $Script:TheStatusItemHeaderWindow.UpdateAllData(
                    $this.PageRefs[$this.Listing.ActiveIndex].Item1.ExamineString,
                    $this.PageRefs[$this.Listing.ActiveIndex].Item1.PlayerEffectString
                )
            
                Break
            }

            33 {  # PAGE UP
                If($this.ZeroPageActive -EQ $true) {
                    Return
                }
                
                $this.TurnPageUp()

                Break
            }

            34 {  # PAGE DOWN
                If($this.ZeroPageActive -EQ $true) {
                    Return
                }
                
                $this.TurnPageDown()

                Break
            }
        }    
    }
}
