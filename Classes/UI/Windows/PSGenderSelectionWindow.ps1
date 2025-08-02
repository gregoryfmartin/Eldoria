using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# PS GENDER SELECTION WINDOW
#
# ALLOWS THE PLAYER TO SELECT A GENDER FOR THEIR CHARACTER.
#
###############################################################################

Class PSGenderSelectionWindow : WindowBase {
    Static [Int]$WindowLTRow    = 1
    Static [Int]$WindowLTColumn = 25
    Static [Int]$WindowRBRow    = 3
    Static [Int]$WindowRBColumn = 36

    Static [String]$PlayerChevronCharacter      = '❱'
    Static [String]$PlayerChevronBlankCharacter = ' '
    Static [String]$MaleSymbol                  = "`u{2642}"
    Static [String]$FemaleSymbol                = "`u{2640}"
    Static [String]$WindowTitle                 = 'Gender'

    [Int]$ActiveChevronIndex
    [Boolean]$PlayerChevronDirty
    [Boolean]$MaleSymbolDirty
    [Boolean]$FemaleSymbolDirty
    [Boolean]$IsActive
    [Boolean]$HasBorderBeenRedrawn
    [ATCoordinates]$MaleSymbolDrawCoords
    [ATCoordinates]$FemaleSymbolDrawCoords
    [List[ValueTuple[[ATString], [Boolean]]]]$Chevrons
    [ATString]$MaleDisplay
    [ATString]$FemaleDisplay
    [Gender]$SelectedGender

    PSGenderSelectionWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [PSGenderSelectionWindow]::WindowLTRow
            Column = [PSGenderSelectionWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [PSGenderSelectionWindow]::WindowRBRow
            Column = [PSGenderSelectionWindow]::WindowRBColumn
        }

        $this.UpdateDimensions()
        $this.SetupTitle([PSGenderSelectionWindow]::WindowTitle, [CCTextDefault24]::new())

        $this.ActiveChevronIndex   = 0
        $this.PlayerChevronDirty   = $true
        $this.MaleSymbolDirty      = $true
        $this.FemaleSymbolDirty    = $true
        $this.IsActive             = $false
        $this.HasBorderBeenRedrawn = $false
        $this.SelectedGender       = [Gender]::Unisex # THIS IS A TOTAL BS DEFAULT VALUE; IT SHOULDN'T BE THIS LATER!

        $this.MaleSymbolDrawCoords = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 1
            Column = $this.LeftTop.Column + 3
        }
        $this.FemaleSymbolDrawCoords = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 1
            Column = $this.LeftTop.Column + 8
        }

        $this.MaleDisplay = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates     = $this.MaleSymbolDrawCoords
            }
            UserData   = [PSGenderSelectionWindow]::MaleSymbol
            UseATReset = $true
        }
        $this.FemaleDisplay = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates     = $this.FemaleSymbolDrawCoords
            }
            UserData   = [PSGenderSelectionWindow]::FemaleSymbol
            UseATReset = $true
        }

        $this.CreateChevrons()
    }

    [Void]CreateChevrons() {
        $this.Chevrons = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.MaleSymbolDrawCoords.Row
                            Column = $this.MaleSymbolDrawCoords.Column - 1
                        }
                    }
                    UserData   = "$([PSGenderSelectionWindow]::PlayerChevronCharacter)"
                    UseATReset = $true
                },
                $true
            )
        )
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.FemaleSymbolDrawCoords.Row
                            Column = $this.FemaleSymbolDrawCoords.Column - 1
                        }
                    }
                    UserData   = "$([PSGenderSelectionWindow]::PlayerChevronBlankCharacter)"
                    UseATReset = $true
                },
                $false
            )
        )
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

        If($this.MaleSymbolDirty -EQ $true) {
            Write-Host "$($this.MaleDisplay.ToAnsiControlSequenceString())"
            $this.MaleSymbolDirty = $false
        }

        If($this.FemaleSymbolDirty -EQ $true) {
            Write-Host "$($this.FemaleDisplay.ToAnsiControlSequenceString())"
            $this.FemaleSymbolDirty = $false
        }

        If($this.PlayerChevronDirty -EQ $true) {
            Foreach($c in $this.Chevrons) {
                Write-Host "$($c.Item1.ToAnsiControlSequenceString())"
            }
            $this.PlayerChevronDirty = $false
        }
    }

    [Void]HandleInput() {
        $keyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')
        Switch($keyCap.VirtualKeyCode) {
            13 { # ENTER
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiSelectionValid)
                    $Script:TheSfxMPlayer.Play()
                } Catch {}
                
                If($this.ActiveChevronIndex -EQ 0) {
                    $this.SelectedGender = [Gender]::Male
                } Elseif($this.ActiveChevronIndex -EQ 1) {
                    $this.SelectedGender = [Gender]::Female
                }
                
                If($null -NE $Script:ThePSBonusPointAllocWindow) {
                    $Script:ThePSBonusPointAllocWindow.IsActive = $true
                    $Script:ThePSBonusPointAllocWindow.HasBorderBeenRedrawn = $false
                    
                    $Script:ThePSBonusPointAllocWindow.SetupAtkPromptActual()
                    $Script:ThePSBonusPointAllocWindow.SetupDefPromptActual()
                    $Script:ThePSBonusPointAllocWindow.SetupMatPromptActual()
                    $Script:ThePSBonusPointAllocWindow.SetupMdfPromptActual()
                    $Script:ThePSBonusPointAllocWindow.SetupSpdPromptActual()
                    
                    $Script:ThePSBonusPointAllocWindow.AtkPromptDirty = $true
                    $Script:ThePSBonusPointAllocWindow.DefPromptDirty = $true
                    $Script:ThePSBonusPointAllocWindow.MatPromptDirty = $true
                    $Script:ThePSBonusPointAllocWindow.MdfPromptDirty = $true
                    $Script:ThePSBonusPointAllocWindow.SpdPromptDirty = $true
                    
                    $Script:ThePSBonusPointAllocWindow.RerollStats()
                }
                
                If($null -NE $Script:ThePSProfileSelectWindow) {
                    $Script:ThePSProfileSelectWindow.ProfileImageProbe = 0
                    $Script:ThePSProfileSelectWindow.ProfileImgDirty = $true
                    $Script:ThePSProfileSelectWindow.Draw()
                }

                $Script:ThePssSubstate = [PlayerSetupScreenStates]::PlayerSetupPointAllocate
                
                Break
            }
            
            27 { # ESCAPE
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {}
                
                $Script:ThePssSubstate = [PlayerSetupScreenStates]::PlayerSetupNameEntry
                
                Break
            }
            
            37 { # LEFT ARROW
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {}
                
                $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = [PSGenderSelectionWindow]::PlayerChevronBlankCharacter
                $this.ActiveChevronIndex                                = ($this.ActiveChevronIndex - 1 + $this.Chevrons.Count) % $this.Chevrons.Count
                $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = [PSGenderSelectionWindow]::PlayerChevronCharacter
                $this.PlayerChevronDirty                                = $true
                
                Break
            }
            
            39 { # RIGHT ARROW
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {}
                
                $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = [PSGenderSelectionWindow]::PlayerChevronBlankCharacter
                $this.ActiveChevronIndex                                = ($this.ActiveChevronIndex + 1) % $this.Chevrons.Count
                $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = [PSGenderSelectionWindow]::PlayerChevronCharacter
                $this.PlayerChevronDirty                                = $true
                
                Break
            }
        }
    }

    [Void]SetAsActive() {
        $this.IsActive                                          = $true
        $this.PlayerChevronDirty                                = $true
        $this.MaleSymbolDirty                                   = $true
        $this.FemaleSymbolDirty                                 = $true
        $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
        $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = [PSGenderSelectionWindow]::PlayerChevronBlankCharacter
        $this.ActiveChevronIndex                                = 0 # Reset to male as default selection
        $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
        $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = [PSGenderSelectionWindow]::PlayerChevronCharacter
        $this.PlayerChevronDirty                                = $true
    }

    [Void]SetAsInactive() {
        $this.IsActive           = $false
        $this.PlayerChevronDirty = $true
    }
}
