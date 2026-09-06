using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# UI CONTAINER
#
# A DERIVATION OF A LONG-STANDING LEGACY CLASS NAMED WINDOWBASE.
#
# A UI CONTAINER IS EXACTLY THAT: A CONTAINER. EXCEPT IT'S A CONTAINER IN A
# SPIRITUAL SENSE. IT DOESN'T CONFORM CHILD ELEMENTS TO ITS BOUNDARIES AND
# DOESN'T REALLY CARE ABOUT LAYING ELEMENTS OUT IN WHATEVER FASHION YOU MIGHT
# CONCEIVE. IT'S REALLY A MEANS OF PLACING A MEASURED BORDER ON THE BUFFER
# IN A SPECIFIC LOCATION.
#
# THE VERSION SHOWN HERE IS DERIVED FROM BURNT LATTE. IT EXTENDS THE ORIGINAL
# DESIGN BY ADDING SUPPORT FOR INDEPENDENT LEFT AND RIGHT BORDER CHARACTERS,
# AS WELL AS ADDING A TITLE. LEGACY DERIVED CLASSES WILL BE REQUIRED TO CHANGE
# CERTAIN INITIALIZATION PROCESSES TO FACILITATE DERIVATION FROM THIS VERSION.
#
# NEWER ADDITIONS TO THIS CODE ARE INTENDED TO ADD CORNER CHARACTERS TO THE
# SPEC. THIS IS A DERIVATIVE OF PWSHSPECTRECONSOLE (THANKS TO TRACKD FOR THIS).
# I WASN'T DOING THIS ORIGINALLY, AND IT SEEMS LIKE IT MAY GIVE A BIT OF A
# BETTER VISUAL EXPERIENCE, ESPECIALLY SINCE I MAY NOT BE ABLE TO USE SAID
# LIBRARY TO RENDER THE GAME AFTER TALKING WTIH HIM. THE BORDERS DON'T CARRY
# WITH THEM DEDICATED DIRTY FLAGS.
#
###############################################################################

Class UIContainer : UIBase {
    Static [Hashtable]$WindowDesignRounded = @{
        [WindowBorderPart]::LeftTop     = '╭'
        [WindowBorderPart]::Top         = '─'
        [WindowBorderPart]::RightTop    = '╮'
        [WindowBorderPart]::Left        = '│'
        [WindowBorderPart]::Right       = '│'
        [WindowBorderPart]::LeftBottom  = '╰'
        [WindowBorderPart]::Bottom      = '─'
        [WindowBorderPart]::RightBottom = '╯'
    }

    Static [Hashtable]$WindowDesignSquare = @{
        [WindowBorderPart]::LeftTop     = '┌'
        [WindowBorderPart]::Top         = '─'
        [WindowBorderPart]::RightTop    = '┐'
        [WindowBorderPart]::Left        = '│'
        [WindowBorderPart]::Right       = '│'
        [WindowBorderPart]::LeftBottom  = '└'
        [WindowBorderPart]::Bottom      = '─'
        [WindowBorderPart]::RightBottom = '┘'
    }

    [Int]$Width
    [Int]$Height
    [Boolean]$UseTitle
    [Boolean]$TitleDirty
    [Boolean]$ComplexTitle
    [Boolean]$Active
    [Boolean[]]$BorderDrawDirty
    [ATCoordinates]$LeftTop
    [ATCoordinates]$RightBottom
    [TrueColor]$TitleColor
    [TrueColor[]]$BorderDrawColors
    [String]$Title
    [Hashtable]$CurrentWindowDesigns

    UIContainer() : base() {
        $this.LeftTop          = [ATCoordinatesNone]::new()
        $this.RightBottom      = [ATCoordinatesNone]::new()
        $this.BorderDrawColors = [TrueColor[]](
            [ColorLibrary]::WindowBorderActiveColor,
            [ColorLibrary]::WindowBorderActiveColor,
            [ColorLibrary]::WindowBorderActiveColor,
            [ColorLibrary]::WindowBorderActiveColor,
            [ColorLibrary]::WindowBorderActiveColor,
            [ColorLibrary]::WindowBorderActiveColor,
            [ColorLibrary]::WindowBorderActiveColor,
            [ColorLibrary]::WindowBorderActiveColor
        )
        $this.BorderDrawDirty = [Boolean[]](
            $true,
            $true,
            $true,
            $true
        )
        $this.Title                = ''
        $this.UseTitle             = $false
        $this.TitleDirty           = $false
        $this.ComplexTitle         = $false
        $this.Active               = $false
        $this.TitleColor           = [ColorLibrary]::TextColor
        $this.CurrentWindowDesigns = [UIContainer]::WindowDesignRounded

        $this.Subscribe(@{
            'SMUiElementActive_OnEnter' = {
                Param([Context]$Context)
                [UIContainer]$Self = $Context.References[0]
                $Self.BorderDrawColors = [TrueColor[]](
                    [ColorLibrary]::WindowBorderActiveColor,
                    [ColorLibrary]::WindowBorderActiveColor,
                    [ColorLibrary]::WindowBorderActiveColor,
                    [ColorLibrary]::WindowBorderActiveColor,
                    [ColorLibrary]::WindowBorderActiveColor,
                    [ColorLibrary]::WindowBorderActiveColor,
                    [ColorLibrary]::WindowBorderActiveColor,
                    [ColorLibrary]::WindowBorderActiveColor
                )
                $Self.TitleColor = [ColorLibrary]::TextActiveColor
                $Self.Active     = $true
                $Self.SetAllDirty()
            }
            'SMUiElementInactive_OnEnter' = {
                Param([Context]$Context)
                [UIContainer]$Self = $Context.References[0]
                $Self.BorderDrawColors = [TrueColor[]](
                    [ColorLibrary]::WindowBorderInactiveColor,
                    [ColorLibrary]::WindowBorderInactiveColor,
                    [ColorLibrary]::WindowBorderInactiveColor,
                    [ColorLibrary]::WindowBorderInactiveColor,
                    [ColorLibrary]::WindowBorderInactiveColor,
                    [ColorLibrary]::WindowBorderInactiveColor,
                    [ColorLibrary]::WindowBorderInactiveColor,
                    [ColorLibrary]::WindowBorderInactiveColor
                )
                $Self.TitleColor = [ColorLibrary]::TextInactiveColor
                $Self.Active     = $false
                $Self.SetAllDirty()
            }
        })
    }

    [Void]UpdateDimensions() {
        $this.Width  = $this.RightBottom.Column - $this.LeftTop.Column
        $this.Height = $this.RightBottom.Row - $this.LeftTop.Row
    }

    [Void]SetupTitle(
        [String]$Title,
        [TrueColor]$Color
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

    [Void]Activate(
        [Context]$Context
    ) {
        ([UIBase]$this).Activate([Context]::new(@(
            $this,
            $Context
        )))
    }

    [Void]Deactivate(
        [Context]$Context
    ) {
        ([UIBase]$this).Deactivate([Context]::new(@(
            $this,
            $Context
        )))
    }

    [Void]Update(
        [Context]$Context
    ) {
        ([UIBase]$this).Update([Context]::new(@(
            $this,
            $Context
        )))
    }

    [Void]ToggleActive(
        [Context]$Context
    ) {
        If($this.BaseStateMachine.CurrentState -EQ [SMUiElementStateMachine]::StateActive) {
            $this.Deactivate($Context)
        } Else {
            $this.Activate($Context)
        }
    }

    [Void]SetBorderColor(
        [TrueColor]$Color
    ) {
        If($this.Active -EQ $true) {
            $this.BorderDrawColors = [TrueColor[]](
                $Color,
                $Color,
                $Color,
                $Color,
                $Color,
                $Color,
                $Color,
                $Color
            )
            $this.SetAllDirty()
        }
    }

    [Void]SetBorderColors(
        [TrueColor[]]$Colors
    ) {
        If($this.Active -EQ $true) {
            $this.BorderDrawColors = $Colors
            $this.SetAllDirty()
        }
    }

    [Void]Draw() {
        [ATStringComposite]$BorderTop    = [ATStringComposite]::new()
        [ATStringComposite]$BorderBottom = [ATStringComposite]::new()
        [ATStringComposite]$BorderLeft   = [ATStringComposite]::new()
        [ATStringComposite]$BorderRight  = [ATStringComposite]::new()
        [ATString]$ATTitle               = [ATStringNone]::new()

        If($this.BorderDrawDirty[[WindowBorderPartDirty]::Top] -EQ $true) {
            $BorderTop = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::LeftTop]
                        Coordinates     = $this.LeftTop
                    }
                    UserData = "$($this.CurrentWindowDesigns[[WindowBorderPart]::LeftTop])"
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::Top]
                    }

                    # I HAVE OFFICIALLY COMITTED THE CARDINAL SIN OF MULTIPLYING A STRING WITH AN INTEGER
                    # TO REPEAT INLINE.
                    # FUCK ME. FUCK ME. FUCK ME.
                    UserData = "$($this.CurrentWindowDesigns[[WindowBorderPart]::Top] * ($this.Width - 1))"
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::RightTop]
                    }
                    UserData   = "$($this.CurrentWindowDesigns[[WindowBorderPart]::RightTop])"
                    UseATReset = $true
                }
            ))
            $this.BorderDrawDirty[[WindowBorderPartDirty]::Top] = $false
        }

        If($this.BorderDrawDirty[[WindowBorderPartDirty]::Bottom] -EQ $true) {
            $BorderBottom = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::LeftBottom]
                        Coordinates     = [ATCoordinates]::new($this.RightBottom.Row, $this.LeftTop.Column)
                    }
                    UserData = "$($this.CurrentWindowDesigns[[WindowBorderPart]::LeftBottom])"
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::Bottom]
                    }
                    UserData = "$($this.CurrentWindowDesigns[[WindowBorderPart]::Bottom] * ($this.Width - 1))"
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::RightBottom]
                    }
                    UserData   = "$($this.CurrentWindowDesigns[[WindowBorderPart]::RightBottom])"
                    UseATReset = $true
                }
            ))
            $this.BorderDrawDirty[[WindowBorderPartDirty]::Bottom] = $false
        }

        If($this.BorderDrawDirty[[WindowBorderPartDirty]::Left] -EQ $true) {
            $BorderLeft = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::Left]
                        Coordinates     = [ATCoordinates]::new($this.LeftTop.Row + 1, $this.LeftTop.Column)
                    }
                    UserData = $(
                        Invoke-Command -ScriptBlock {
                            [String]$T = ''

                            For([Int]$A = 0; $A -LT $this.Height; $A++) {
                                [ATCoordinates]$B  = [ATCoordinates]::new(($this.LeftTop.Row + 1) + $A, $this.LeftTop.Column)
                                $T                += "$($this.CurrentWindowDesigns[[WindowBorderPart]::Left])$($B.ToAnsiControlSequenceString())"
                            }

                            Return "$($T)"
                        }
                    )
                }
            ))
            $this.BorderDrawDirty[[WindowBorderPartDirty]::Left] = $true
        }

        If($this.BorderDrawDirty[[WindowBorderPartDirty]::Right] -EQ $true) {
            $BorderRight = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.BorderDrawColors[[WindowBorderPart]::Right]
                        Coordinates     = [ATCoordinates]::new($this.LeftTop.Row + 1, $this.RightBottom.Column)
                    }
                    UserData = $(
                        Invoke-Command -ScriptBlock {
                            [String]$T = ''

                            For([Int]$A = 0; $A -LT $this.Height; $A++) {
                                [ATCoordinates]$B  = [ATCoordinates]::new(($this.LeftTop.Row + 1) + $A, $this.RightBottom.Column)
                                $T                += "$($this.CurrentWindowDesigns[[WindowBorderPart]::Right])$($B.ToAnsiControlSequenceString())"
                            }

                            Return "$($T)"
                        }
                    )
                }
            ))
            $this.BorderDrawDirty[[WindowBorderPartDirty]::Right] = $false
        }

        Write-Host "$($BorderTop.ToAnsiControlSequenceString())$($BorderBottom.ToAnsiControlSequenceString())$($BorderLeft.ToAnsiControlSequenceString())$($BorderRight.ToAnsiControlSequenceString())"

        If($this.UseTitle -EQ $true) {
            If($this.TitleDirty -EQ $true) {
                $ATTitle = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.TitleColor
                        Coordinates     = [ATCoordinates]::new($this.LeftTop.Row, $this.LeftTop.Column + 2)
                    }
                    UserData   = "$($this.Title)"
                    UseATReset = $true
                }

                Write-Host "$($ATTitle.ToAnsiControlSequenceString())"
                $this.TitleDirty = $false
            }
        }
    }
}
