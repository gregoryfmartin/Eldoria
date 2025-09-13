using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# WINDOW BASE
#
# INTENDED TO BE USED AS THE FOUNDATION FOR MORE SPECIFIC "WINDOWS". THIS CLASS
# ISN'T INTENDED TO BE INSTANTIATED DIRECTLY FOR ANY REASON OTHER THAN TESTING.
#
# THE VERSION SHOWN HERE IS DERIVED FROM BURNT LATTE. IT EXTENDS THE ORIGINAL
# DESIGN BY ADDING SUPPORT FOR INDEPENDENT LEFT AND RIGHT BORDER CHARACTERS,
# AS WELL AS ADDING A TITLE. LEGACY DERIVED CLASSES WILL BE REQUIRED TO CHANGE
# CERTAIN INITIALIZATION PROCESSES TO FACILITATE DERIVATION FROM THIS VERSION.
#
# NEWER ADDITIONS TO THIS CODE ARE INTENDED TO ADD CORNER CHARACTERS TO THE
# SPEC. THIS IS A DERIVATIVE OF PWSHSPECTRECONSOLE (THANKS TO TRACKD FOR THIS).
# I WASN'T DOING THIS ORIGINALLY, AND IT SEEMS LIKE IT MAY GIVE A BIT OF A
# BETTER VISUAL EXPERIENCE, ESPCIALLY SINCE I MAY NOT BE ABLE TO USE SAID
# LIBRARY TO RENDER THE GAME AFTER TALKING WITH HIM. THE BORDERS DON'T CARRY
# WITH THEM DEDICATED DIRTY FLAGS. IF THE TOP BORDER IS FLAGGED AS BEING DIRTY,
# THE TOP-LEFT CORNER, TOP, AND TOP-RIGHT CORNER CHARACTERS ARE RENDERED. THE
# SAME LOGIC APPLIES TO THE BOTTOM BORDER. THE LEFT AND RIGHT BORDERS ARE JUST
# THE BORDER CHARACTERS.
#
###############################################################################

Class WindowBase {
    [ATCoordinates]$LeftTop
    [ATCoordinates]$RightBottom
    [ConsoleColor24[]]$BorderDrawColors
    [Boolean[]]$BorderDrawDirty
    [Int]$Width
    [Int]$Height

    [String]$Title
    [Boolean]$UseTitle
    [Boolean]$TitleDirty
    [Boolean]$ComplexTitle
    [ConsoleColor24]$TitleColor

    WindowBase() {
        $this.LeftTop          = [ATCoordinatesNone]::new()
        $this.RightBottom      = [ATCoordinatesNone]::new()
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
            $true
        )
        $this.Title        = ''
        $this.UseTitle     = $false
        $this.TitleDirty   = $false
        $this.ComplexTitle = $false
        $this.TitleColor   = [CCTextDefault24]::new()
        $this.UpdateDimensions()
    }

    [Void]Draw() {
        [ATStringComposite]$Bt = [ATStringComposite]::new()
        [ATStringComposite]$Bb = [ATStringComposite]::new()
        [ATStringComposite]$Bl = [ATStringComposite]::new()
        [ATStringComposite]$Br = [ATStringComposite]::new()

        If($this.BorderDrawDirty[[WindowBorderPart]::Top] -EQ $true) {
            $Bt = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::LeftTop]
                        Coordinates     = $this.LeftTop
                    }
                    UserData = $($Script:CurrentWindowDesign[[WindowBorderPart]::LeftTop])
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::Top]
                    }

                    # I HAVE OFFICIALLY COMMITTED THE CARDINAL SIN OF MULTIPLYING A STRING WITH AN INTEGER
                    # TO REPEAT INLINE.
                    # FUCK ME. FUCK ME. FUCK ME.
                    UserData = $($Script:CurrentWindowDesign[[WindowBorderPart]::Top] * ($this.Width - 1))
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::RightTop]
                    }
                    UserData   = $($Script:CurrentWindowDesign[[WindowBorderPart]::RightTop])
                    UseATReset = $true
                }
            ))
            $this.BorderDrawDirty[[WindowBorderPartDirty]::Top] = $false
        }

        If($this.BorderDrawDirty[[WindowBorderPartDirty]::Bottom] -EQ $true) {
            $Bb = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::LeftBottom]
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.RightBottom.Row
                            Column = $this.LeftTop.Column
                        }
                    }
                    UserData = $($Script:CurrentWindowDesign[[WindowBorderPart]::LeftBottom])
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::Bottom]
                    }
                    UserData = $($Script:CurrentWindowDesign[[WindowBorderPart]::Bottom] * ($this.Width - 1))
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::RightBottom]
                    }
                    UserData   = $($Script:CurrentWindowDesign[[WindowBorderPart]::RightBottom])
                    UseATReset = $true
                }
            ))
            $this.BorderDrawDirty[[WindowBorderPartDirty]::Bottom] = $false
        }

        If($this.BorderDrawDirty[[WindowBorderPartDirty]::Left] -EQ $true) {
            # THE CORNERS WILL ALREADY HAVE BEEN DRAWN AT THIS POINT, SO WE JUST NEED TO REPEAT THE LEFT CHARACTER VERTICALLY
            $Bl = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::Left]
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row + 1
                            Column = $this.LeftTop.Column
                        }
                    }
                    UserData = $(
                        Invoke-Command -ScriptBlock {
                            [String]$T = ''

                            For($A = 0; $A -LT $this.Height; $A++) {
                                [ATCoordinates]$B = [ATCoordinates]@{
                                    Row    = ($this.LeftTop.Row + 1) + $A
                                    Column = $this.LeftTop.Column
                                }
                                $T += "$($Script:CurrentWindowDesign[[WindowBorderPart]::Left])$($B.ToAnsiControlSequenceString())"
                            }

                            Return $T
                        }
                    )
                }
            ))
            $this.BorderDrawDirty[[WindowBorderPartDirty]::Left] = $true
        }

        If($this.BorderDrawDirty[[WindowBorderPartDirty]::Right] -EQ $true) {
            $Br = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::Right]
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row + 1
                            Column = $this.RightBottom.Column
                        }
                    }
                    UserData = $(
                        Invoke-Command -ScriptBlock {
                            [String]$T = ''

                            For($A = 0; $A -LT $this.Height; $A++) {
                                [ATCoordinates]$B = [ATCoordinates]@{
                                    Row    = ($this.LeftTop.Row + 1) + $A
                                    Column = $this.RightBottom.Column
                                }
                                $T += "$($Script:CurrentWindowDesign[[WindowBorderPart]::Right])$($B.ToAnsiControlSequenceString())"
                            }

                            Return $T
                        }
                    )
                }
            ))
            $this.BorderDrawDirty[[WindowBorderPartDirty]::Right] = $false
        }

        Write-Host "$($Bt.ToAnsiControlSequenceString())$($Bb.ToAnsiControlSequenceString())$($Bl.ToAnsiControlSequenceString())$($Br.ToAnsiControlSequenceString())"

        If($this.UseTitle -EQ $true) {
            If($this.TitleDirty -EQ $true) {
                [ATString]$A = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        # ForegroundColor = $this.TitleColor
                        Coordinates = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row
                            Column = $this.LeftTop.Column + 2
                        }
                    }
                    UserData   = $this.Title
                    UseATReset = $true
                }

                Write-Host "$($A.ToAnsiControlSequenceString())"
                $this.TitleDirty = $false
            }
        }
    }

    [Void]UpdateDimensions() {
        $this.Width  = $this.RightBottom.Column - $this.LeftTop.Column
        $this.Height = $this.RightBottom.Row - $this.LeftTop.Row
    }

    [Void]SetupTitle(
        [String]$Title,
        [ConsoleColor24]$Color
    ) {
        $this.UseTitle   = $true
        $this.TitleDirty = $true
        $this.Title      = $Title
        $this.TitleColor = $Color
    }
    
    [Void]SetAllDirty() {
        $this.BorderDrawDirty = [Boolean[]]@(
            $true,
            $true,
            $true,
            $true
        )

        If($this.UseTitle -EQ $true) {
            $this.TitleDirty = $true
        }
    }
}

