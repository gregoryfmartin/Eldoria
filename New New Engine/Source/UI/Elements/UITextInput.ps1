using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest





###############################################################################
#
# UI TEXT INPUT
#
###############################################################################

Class UITextInput : UIBase {
    [Int]$MaxCharacters
    [String]$InputBuffer
    [ATCoordinates]$DrawCoordinates

    UITextInput() : base() {
        $this.MaxCharacters   = 10
        $this.InputBuffer     = ''
        $this.DrawCoordinates = [ATCoordinates]::new(1, 1)
        $this.Dirty           = $true
        $this.SetupStates()
    }

    UITextInput(
        [Int]$MaxCharacters
    ) : base() {
        $this.MaxCharacters   = $MaxCharacters
        $this.InputBuffer     = ''
        $this.DrawCoordinates = [ATCoordinates]::new(1, 1)
        $this.Dirty           = $true
        $this.SetupStates()
    }

    UITextInput(
        [Int]$MaxCharacters,
        [ATCoordinates]$DrawCoordinates
    ) : base() {
        $this.MaxCharacters   = $MaxCharacters
        $this.InputBuffer     = ''
        $this.DrawCoordinates = $DrawCoordinates
        $this.Dirty           = $true
        $this.SetupStates()
    }

    [Void]SetupStates() {
        $this.Subscribe(@{
            'SMUiElementInactive_OnEnter' = {
                Param(
                    [Context]$Context
                )

                [UITextInput]$SelfElement = $Context.References[0]

                $SelfElement.Prefix.ForegroundColor = [ColorLibrary]::UITextInputInactiveColor
                $SelfElement.Dirty                  = $true
            }
            'SMUiElementActive_OnEnter' = {
                Param(
                    [Context]$Context
                )

                [UITextInput]$SelfElement = $Context.References[0]

                $SelfElement.Prefix.ForegroundColor = [ColorLibrary]::UITextInputActive
                $SelfElement.Dirty                  = $true
            }
            'SMUiElementFocused_OnEnter' = {
                Param(
                    [Context]$Context
                )

                [UITextInput]$SelfElement = $Context.References[0]

                $SelfElement.Prefix.Decorations = [ATDecoration]@{
                    Italic = $false
                }
                $SelfElement.Dirty = $true
            }
        })
    }

    [Void]Update(
        [Context]$Context
    ) {
        ([UIBase]$this).Update($Context)

        # Only process input if active and focused
        If($this.Behavior.Active -EQ $true -AND $this.Behavior.CanHaveFocus -EQ $true -AND $this.Behavior.HasFocus -EQ $true) {
            [List[ConsoleKeyInfo]]$KeysPressed = $Context.References[[SMState]::ContextKeysPressed]

            If($KeysPressed.Count -GT 0) {
                Foreach($KeyPress in $KeysPressed) {
                    If($KeyPress.Key -EQ [ConsoleKey]::Backspace) {
                        If($this.InputBuffer.Length -GT 0) {
                            $this.InputBuffer = $this.InputBuffer.Substring(0, $this.InputBuffer.Length - 1)
                            $this.Dirty = $true
                        }
                    } ElseIf ($KeyPress.Key -NE [ConsoleKey]::Enter -AND $KeyPress.Key -NE [ConsoleKey]::Escape -AND $KeyPress.Key -NE [ConsoleKey]::Tab) {
                        If($this.InputBuffer.Length -LT $this.MaxCharacters) {
                            # Check if printable character (simplistic check)
                            If(![char]::IsControl($KeyPress.KeyChar)) {
                                $this.InputBuffer += $KeyPress.KeyChar
                                $this.Dirty = $true
                            }
                        }
                    }
                }
            }
        }
    }

    [String]ToAnsiControlSequenceString() {
        [ATStringComposite]$A = [ATStringComposite]::new()

        [String]$DisplayText = $this.InputBuffer.PadRight($this.MaxCharacters, '_')

        If($this.Behavior.Active -EQ $true) {
            If($this.Behavior.CanHaveFocus -EQ $true -AND $this.Behavior.HasFocus -EQ $true) {
                $A.CompositeActual.Add(
                    [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [ColorLibrary]::UITextInputHasFocus
                            Coordinates     = $this.DrawCoordinates
                        }
                        UserData   = "$DisplayText"
                        UseATReset = $true
                    }
                )
            } Else {
                $A.CompositeActual.Add(
                    [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [ColorLibrary]::UITextInputActive
                            Coordinates     = $this.DrawCoordinates
                        }
                        UserData   = "$DisplayText"
                        UseATReset = $true
                    }
                )
            }
        } Else {
            $A.CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [ColorLibrary]::UITextInputInactiveColor
                        Coordinates     = $this.DrawCoordinates
                    }
                    UserData   = "$DisplayText"
                    UseATReset = $true
                }
            )
        }

        Return "$($A.ToAnsiControlSequenceString())"
    }
}
