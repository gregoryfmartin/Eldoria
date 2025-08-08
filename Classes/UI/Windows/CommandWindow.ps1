using namespace System
using namespace System.Management.Automation.Host

Set-StrictMode -Version Latest

###############################################################################
#
# COMMAND WINDOW
#
# THIS IS THE WINDOW THAT ALLOWS THE USER TO INPUT COMMANDS AND ALSO SHOWS THE
# COMMAND HISTORY (FIVE MOST RECENT COMMANDS).
#
###############################################################################

Class CommandWindow : WindowBase {
    Static [Int]$CommandHistoryARef    = 0
    Static [Int]$CommandHistoryBRef    = 1
    Static [Int]$CommandHistoryCRef    = 2
    Static [Int]$CommandHistoryDRef    = 3
    Static [Int]$CommandHistoryERef    = 4
    Static [Int]$WindowLTRow           = 12
    Static [Int]$WindowLTColumn        = 1
    Static [Int]$WindowRBRow           = 20
    Static [Int]$WindowRBColumn        = 19
    Static [Int]$DrawColumnOffset      = 1
    Static [Int]$DrawDivRowOffset      = 2
    Static [Int]$DrawHistoryDRowOffset = 3
    Static [Int]$DrawHistoryCRowOffset = 4
    Static [Int]$DrawHistoryBRowOffset = 5
    Static [Int]$DrawHistoryARowOffset = 6
    Static [Int]$DrawHistoryERowOffset = 7

    Static [String]$CommandBlankData = '                '
    Static [String]$WindowCommandDiv = '─────────────────'
    Static [String]$WindowTitle      = 'Commands'

    Static [ATCoordinates]$CommandDivDrawCoordinates      = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryEDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryDDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryCDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryBDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryADrawCoordinates = [ATCoordinatesNone]::new()
    
    Static [Coordinates]$CursorDefaultPosition = [Coordinates]::new(2, 18)

    Static [ConsoleColor24]$HistoryEntryValid   = [CCAppleNGreenLight24]::new()
    Static [ConsoleColor24]$HistoryEntryError   = [CCAppleNRedLight24]::new()
    Static [ConsoleColor24]$HistoryBlankColor   = [CCBlack24]::new()
    Static [ConsoleColor24]$CommandDivDrawColor = [CCTextDefault24]::new()
    Static [ATString]$CommandDiv                = [ATStringNone]::new()
    Static [ATString]$CommandBlank              = [ATStringNone]::new()
    Static [ATString]$CommandHistBlank          = [ATStringNone]::new()

    [ATString]$CommandActual
    [ATString[]]$CommandHistory

    [Boolean]$CommandDivDirty
    [Boolean]$CommandHistoryDirty

    CommandWindow() : base() {
        $this.LeftTop          = [ATCoordinates]::new([CommandWindow]::WindowLTRow, [CommandWindow]::WindowLTColumn)
        $this.RightBottom      = [ATCoordinates]::new([CommandWindow]::WindowRBRow, [CommandWindow]::WindowRBColumn)

        $this.UpdateDimensions()
        $this.SetupTitle([CommandWindow]::WindowTitle, [CCTextDefault24]::new())

        $this.CommandDivDirty     = $true
        $this.CommandHistoryDirty = $false
        [Int]$rowBase             = $this.RightBottom.Row
        [Int]$columnBase          = $this.LeftTop.Column + [CommandWindow]::DrawColumnOffset

        [CommandWindow]::CommandDivDrawCoordinates = [ATCoordinates]@{
            Row    = ($rowBase - [CommandWindow]::DrawDivRowOffset)
            Column = $columnBase
        }
        [CommandWindow]::CommandHistoryEDrawCoordinates = [ATCoordinates]@{
            Row    = $rowBase - [CommandWindow]::DrawHistoryERowOffset
            Column = $columnBase
        }
        [CommandWindow]::CommandHistoryDDrawCoordinates = [ATCoordinates]@{
            Row    = $rowBase - [CommandWindow]::DrawHistoryDRowOffset
            Column = $columnBase
        }
        [CommandWindow]::CommandHistoryCDrawCoordinates = [ATCoordinates]@{
            Row    = $rowBase - [CommandWindow]::DrawHistoryCRowOffset
            Column = $columnBase
        }
        [CommandWindow]::CommandHistoryBDrawCoordinates = [ATCoordinates]@{
            Row    = $rowBase - [CommandWindow]::DrawHistoryBRowOffset
            Column = $columnBase
        }
        [CommandWindow]::CommandHistoryADrawCoordinates = [ATCoordinates]@{
            Row    = $rowBase - [CommandWindow]::DrawHistoryARowOffset
            Column = $columnBase
        }

        [CommandWindow]::CommandDiv = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CommandWindow]::CommandDivDrawColor
                Coordinates     = [CommandWindow]::CommandDivDrawCoordinates
            }
            UserData   = "$([CommandWindow]::WindowCommandDiv)"
            UseATReset = $true
        }
        [CommandWindow]::CommandBlank = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CommandWindow]::HistoryBlankColor
            }
            UserData   = "$([CommandWindow]::CommandBlankData)"
            UseATReset = $true
        }
        [CommandWindow]::CommandHistBlank = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CommandWindow]::HistoryBlankColor
            }
            UserData   = "$([CommandWindow]::CommandBlankData)"
            UseATReset = $true
        }

        $this.CommandActual                                       = [ATStringNone]::new()
        $this.CommandHistory                                      = New-Object 'ATString[]' 5
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef] = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates     = [CommandWindow]::CommandHistoryADrawCoordinates
            }
            UserData   = "$([CommandWindow]::CommandBlank.UserData)"
            UseATReset = $true
        }
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef] = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates     = [CommandWindow]::CommandHistoryBDrawCoordinates
            }
            UserData   = "$([CommandWindow]::CommandBlank.UserData)"
            UseATReset = $true
        }
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef] = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates     = [CommandWindow]::CommandHistoryCDrawCoordinates
            }
            UserData   = "$([CommandWindow]::CommandBlank.UserData)"
            UseATReset = $true
        }
        $this.CommandHistory[[CommandWindow]::CommandHistoryDRef] = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates     = [CommandWindow]::CommandHistoryDDrawCoordinates
            }
            UserData   = "$([CommandWindow]::CommandBlank.UserData)"
            UseATReset = $true
        }
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef] = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates     = [CommandWindow]::CommandHistoryEDrawCoordinates
            }
            UserData   = "$([CommandWindow]::CommandBlank.UserData)"
            UseATReset = $true
        }
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()
        If($this.CommandDivDirty -EQ $true) {
            Write-Host "$([CommandWindow]::CommandDiv.ToAnsiControlSequenceString())"
            $this.CommandDivDirty = $false
        }
        If($this.CommandHistoryDirty -EQ $true) {
            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryDDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())$($this.CommandHistory[[CommandWindow]::CommandHistoryDRef].ToAnsiControlSequenceString())"
            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryCDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())$($this.CommandHistory[[CommandWindow]::CommandHistoryCRef].ToAnsiControlSequenceString())"
            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryBDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())$($this.CommandHistory[[CommandWindow]::CommandHistoryBRef].ToAnsiControlSequenceString())"
            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryADrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())$($this.CommandHistory[[CommandWindow]::CommandHistoryARef].ToAnsiControlSequenceString())"
            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryEDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())$($this.CommandHistory[[CommandWindow]::CommandHistoryERef].ToAnsiControlSequenceString())"
            $this.CommandHistoryDirty = $false
        }
    }

    [Void]HandleInput() {
        # ENSURE THAT THE CURSOR IS DISPLAYED
        Write-Host "$([ATControlSequences]::CursorShow)"
        
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()
        $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')
        While($keyCap.VirtualKeyCode -NE 13) {
            $cpx = $Script:Rui.CursorPosition.X
            If($cpx -GE 18) {
                Break
            }
            Switch($keyCap.VirtualKeyCode) {
                8 { # BACKSPACE
                    $CurrentX = $Script:Rui.CursorPosition.X
                    If($this.CommandActual.UserData.Length -GT 0) {
                        If($CurrentX -GE 3) {
                            Write-Host " `b" -NoNewline
                            $this.CommandActual.UserData = $this.CommandActual.UserData.Remove($this.CommandActual.UserData.Length - 1, 1)
                        } Else {
                            $this.CommandActual.UserData = $this.CommandActual.UserData.Remove($this.CommandActual.UserData.Length - 1, 1)
                            Write-Host "$([CommandWindow]::CommandBlank.ToAnsiControlSequenceString())" -NoNewline
                            $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()
                        }
                    }

                    If($Script:Rui.CursorPosition.X -LT 3) {
                        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()
                    }
                }

                Default {
                    $this.CommandActual.UserData += $keyCap.Character
                }
            }
            $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')
        }
        $this.InvokeCommandParser()
    }

    [Void]InvokeCommandParser() {
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()
        Write-Host "$([CommandWindow]::CommandBlank.ToAnsiControlSequenceString())" -NoNewline
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()

        If([String]::IsNullOrEmpty($this.CommandActual.UserData.Trim()) -EQ $true) {
            $Script:TheMessageWindow.WriteBadCommandRetortMessage()
            $this.CommandActual.UserData = ''

            Return
        } Else {
            $cmdactSplit = $this.CommandActual.UserData.Trim()
            $cmdactSplit = -SPLIT $this.CommandActual.UserData
            $rootFound   = $Script:TheCommandTable.GetEnumerator() | Where-Object { $_.Name -IEQ $cmdactSplit[0] }
            If($null -NE $rootFound) {
                Switch($cmdactSplit.Length) {
                    1 {
                        Invoke-Command $rootFound.Value
                    }

                    2 {
                        Invoke-Command $rootFound.Value -ArgumentList $cmdactSplit[1]
                    }

                    3 {
                        Invoke-Command $rootFound.Value -ArgumentList $cmdactSplit[1], $cmdactSplit[2]
                    }

                    Default {
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        $Script:TheMessageWindow.WriteBadCommandRetortMessage()
                    }
                }
            } Else {
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteBadCommandRetortMessage()

                Return
            }
        }
    }

    [Void]UpdateCommandHistory(
        [Boolean]$CmdValid
    ) {
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryARef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.ForegroundColor
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.ForegroundColor
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.ForegroundColor
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.ForegroundColor
        $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].UserData               = $this.CommandActual.UserData
        If($CmdValid -EQ $true) {
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.ForegroundColor = [CommandWindow]::HistoryEntryValid
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.Decorations     = [ATDecorationNone]::new()
        } Else {
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.ForegroundColor = [CommandWindow]::HistoryEntryError
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.Decorations = [ATDecoration]@{
                Blink = $true
            }
        }
        $this.CommandActual.UserData = ''
        $this.CommandHistoryDirty    = $true
    }
}

