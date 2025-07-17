using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# PS NAME ENTRY WINDOW
#
# A WINDOW THAT ALLOWS THE USER TO INPUT THE DESIRED PLAYER'S NAME.
#
###############################################################################

Class PSNameEntryWindow : WindowBase {
    Static [Int]$WindowLTRow    = 1
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowRBRow    = 3
    Static [Int]$WindowRBColumn = 16
    
    Static [String]$WindowTitle = 'Name'
    
    # I'M NOT SURE THAT I'D NEED THIS, BUT WE'LL LEAVE IT HERE FOR GIGGLES
    Static [String]$NameBlankData = ' ' * ([PSNameEntryWindow]::WindowRBColumn - 2)
    
    [ATString]$NameActual
    [ATString]$NameBlankActual
    [Boolean]$IsActive
    
    PSNameEntryWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [PSNameEntryWindow]::WindowLTRow
            Column = [PSNameEntryWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [PSNameEntryWindow]::WindowRBRow
            Column = [PSNameEntryWindow]::WindowRBColumn
        }
        
        $this.UpdateDimensions()
        $this.SetupTitle([PSNameEntryWindow]::WindowTitle, [CCTextDefault24]::new())
        
        $this.NameActual = [ATString]@{
            Prefix = [ATStringPrefix]@{
                Coordinates = [ATCoordinates]@{
                    Row    = 10
                    Column = 1
                }
            }
            UseATReset = $true
        }
        $this.NameBlankActual = [ATString]@{
            Prefix = [ATStringPrefix]@{
                Coordinates = [ATCoordinates]@{
                    Row    = 2
                    Column = 2
                }
            }
            UserData   = [PSNameEntryWindow]::NameBlankData
            UseATReset = $true
        }
        $this.IsActive = $false
    }
    
    [Void]Draw() {
        If($this.IsActive -EQ $true) {
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
        } Else {
            $this.BorderDrawColors = [ConsoleColor24[]](
                [CCWindowBorderDefault24]::new(),
                [CCWindowBorderDefault24]::new(),
                [CCWindowBorderDefault24]::new(),
                [CCWindowBorderDefault24]::new(),
                [CCWindowBorderDefault24]::new(),
                [CCWindowBorderDefault24]::new(),
                [CCWindowBorderDefault24]::new(),
                [CCWindowBorderDefault24]::new()
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
        }

        ([WindowBase]$this).Draw()
    }
    
    [Void]HandleInput() {
        $Script:Rui.CursorPosition = ([ATCoordinates]@{ Row = 2; Column = 1 }).ToAutomationCoordinates()
        $KeyCap                    = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
        
        While($KeyCap.VirtualKeyCode -NE 13) {
            $CPX = $Script:Rui.CursorPosition.X

            Switch($KeyCap.VirtualKeyCode) {
                8 {
                    $fpx = $Script:Rui.CursorPosition.X
                    If($fpx -GT 2) {
                        Write-Host "`b `b" -NoNewLine
                        If($this.NameActual.UserData.Length -GT 0) {
                            $this.NameActual.UserData = $this.NameActual.UserData.Remove($this.NameActual.UserData.Length - 1, 1)
                        }
                    } Elseif($fpx -LT 2) {
                        $Script:Rui.CursorPosition = ([ATCoordinates]@{ Row = 2; Column = 1 }).ToAutomationCoordinates()
                    } Elseif($fpx -EQ 2) {
                        Write-Host " `b" -NoNewline
                        If($this.NameActual.UserData.Length -GT 0) {
                            $this.NameActual.UserData = $this.NameActual.UserData.Remove($this.NameActual.UserData.Length - 1, 1)
                        }
                    }

                    Break
                }

                Default {
                    $FPX = $Script:Rui.CursorPosition.X
                    
                    If($FPX -GE ([PSNameEntryWindow]::WindowRBColumn - 2)) {
                        Break
                    } Else {
                        Write-Host "$($KeyCap.Character)" -NoNewLine
                        $this.NameActual.UserData += $KeyCap.Character
                    }
                    
                    Break
                }
            }
            
            $KeyCap = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
        }
        
        # THIS SHOULD LIKELY HAPPEN WHEN THE USER COMES BACK TO THIS STATE FROM A FORWARD STATE
        # Write-Host "$($this.NameBlankActual.ToAnsiControlSequenceString())"
        
        # PLAY A SFX TO ACK THE ENTRY
        Try {
            $Script:TheSfxMPlayer.Open($Script:SfxUiSelectionValid)
            $Script:TheSfxMPlayer.Play()
        } Catch {}
        
        # AT THIS POINT, WE'D NEED TO CHANGE SUBSTATE
        $Script:ThePssSubstate = [PlayerSetupScreenStates]::PlayerSetupGenderSelection
        
        # WRITE THE HIDE CURSOR CSI
        Write-Host "$([ATControlSequences]::CursorHide)"
    }
}
