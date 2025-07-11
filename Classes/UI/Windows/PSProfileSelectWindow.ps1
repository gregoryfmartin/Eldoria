using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# PS PROFILE SELECT WINDOW
#
# ALLOWS THE USER TO SELECT A PROFILE IMAGE FOR THEIR PLAYER CHARACTER.
# I'M VIOLATING SOME OF MY PRINCIPLES HERE AND USING SIXEL.
#
###############################################################################

Class PSProfileSelectWindow : WindowBase {
    Static [Int]$WindowLTRow = 1
    Static [Int]$WindowLTColumn = 41
    Static [Int]$WindowRBRow = 12
    Static [Int]$WindowRBColumn = 70
    
    Static [String]$WindowTitle = 'Profile'
    Static [String]$DialArrowLeftData = "`u{23F4}"
    Static [String]$DialArrowRightData = "`u{23F5}"
    
    Static [ConsoleColor24]$DialArrowHighlightColor = [CCAppleNPinkLight24]::new()
    
    [ATCoordinates]$DrawOffset
    
    [Int]$ProfileImageProbe
    [Boolean]$ProfileImgDirty
    [Boolean]$DialArrowLeftDirty
    [Boolean]$DialArrowRightDirty
    [Boolean]$DialArrowLeftActive
    [Boolean]$DialArrowRightActive
    [ATString[]]$DialArrowsActual

    PSProfileSelectWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row = [PSProfileSelectWindow]::WindowLTRow
            Column = [PSProfileSelectWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row = [PSProfileSelectWindow]::WindowRBRow
            Column = [PSProfileSelectWindow]::WindowRBColumn
        }
        
        $this.UpdateDimensions()
        $this.SetupTitle([PSProfileSelectWindow]::WindowTitle, [CCTextDefault24]::new())
        
        $this.DrawOffset = [ATCoordinates]@{
            Row = $this.LeftTop.Row + 1
            Column = $this.LeftTop.Column + 4
        }
        
        $this.ProfileImageProbe = 0
        $this.ProfileImgDirty = $true
        $this.DialArrowLeftDirty = $true
        $this.DialArrowRightDirty = $true
        $this.DialArrowLeftActive = $false
        $this.DialArrowRightActive = $false
        
        $this.DialArrowsActual = @(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = ($this.Height / 2) + 1
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData = "$([PSProfileSelectWindow]::DialArrowLeftData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row = ($this.Height / 2) + 1
                        Column = $this.RightBottom.Column - 2
                    }
                }
                UserData = "$([PSProfileSelectWindow]::DialArrowRightData)"
                UseATReset = $true
            }
        )
    }
    
    [Void]Draw() {
        ([WindowBase]$this).Draw()
        
        If($this.ProfileImgDirty -EQ $true) {
            Switch($Script:ThePSGenderSelectionWindow.SelectedGender) {
                ([Gender]::Male) {
                    Write-Host "$($this.DrawOffset.ToAnsiControlSequenceString())$($Script:MaleImageData[$this.ProfileImageProbe])"
                }
                
                ([Gender]::Female) {
                    Write-Host "$($this.DrawOffset.ToAnsiControlSequenceString())$($Script:FemaleImageData[$this.ProfileImageProbe])"
                }
            }
            
            # Write-Host "$($this.DrawOffset.ToAnsiControlSequenceString())$($Script:SampleImageA)"
            
            $this.ProfileImgDirty = $false
        }

        If($this.DialArrowLeftDirty -EQ $true) {
            Write-Host "$($this.DialArrowsActual[0].ToAnsiControlSequenceString())"
            
            $this.DialArrowLeftDirty = $false
        }
        
        If($this.DialArrowRightDirty -EQ $true) {
            Write-Host "$($this.DialArrowsActual[1].ToAnsiControlSequenceString())"
            
            $this.DialArrowRightDirty = $false
        }
    }
    
    [Void]HandleInput() {
        $KeyCap = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
        
        Switch($KeyCap.VirtualKeyCode) {
            13 { # ENTER
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen
                Clear-Host
                
                Break
            }
            
            37 { # LEFT ARROW
                If($KeyCap.KeyDown -EQ $true) {
                    Switch($Script:ThePSGenderSelectionWindow.SelectedGender) {
                        ([Gender]::Male) {
                            If($this.ProfileImageProbe -EQ 0) {
                                $this.ProfileImageProbe = ($Script:MaleImageData.Count - 1)
                            } Else {
                                $this.ProfileImageProbe--
                            }
                        
                            Break
                        }
                    
                        ([Gender]::Female) {
                            If($this.ProfileImageProbe -EQ 0) {
                                $this.ProfileImageProbe = ($Script:FemaleImageData.Count - 1)
                            } Else {
                                $this.ProfileImageProbe--
                            }

                            Break
                        }
                    }
                    
                    $this.ProfileImgDirty = $true
                }
                
                Break
            }
            
            39 { # RIGHT ARROW
                Switch($Script:ThePSGenderSelectionWindow.SelectedGender) {
                    ([Gender]::Male) {
                        If($this.ProfileImageProbe -EQ ($Script:MaleImageData.Count - 1)) {
                            $this.ProfileImageProbe = 0
                        } Else {
                            $this.ProfileImageProbe++
                        }
                        
                        Break
                    }
                    
                    ([Gender]::Female) {
                        If($this.ProfileImageProbe -EQ ($Script:FemaleImageData.Count - 1)) {
                            $this.ProfileImageProbe = 0
                        } Else {
                            $this.ProfileImageProbe++
                        }
                        
                        Break
                    }
                }
                
                $this.ProfileImgDirty = $true

                Break
            }
        }
    }
}
