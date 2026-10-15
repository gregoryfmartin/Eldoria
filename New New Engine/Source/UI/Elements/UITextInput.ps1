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
        $this.UseATReset      = $true
        $this.SetupStates()
    }

    UITextInput(
        [Int]$MaxCharacters
    ) : base() {
        $this.MaxCharacters   = $MaxCharacters
        $this.InputBuffer     = ''
        $this.DrawCoordinates = [ATCoordinates]::new(1, 1)
        $this.Dirty           = $true
        $this.UseATReset      = $true
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
        $this.UseATReset      = $true
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

                $SelfElement.Prefix.ForegroundColor = [ColorLibrary]::UITextInputHasFocus
                $SelfElement.Prefix.Decorations = [ATDecoration]@{
                    Italic = $false
                }
                $SelfElement.Dirty = $true
            }
            'SMUiElementFocused_OnUpdate' = {
                Param(
                    [Context]$Context
                )

                [UITextInput]$SelfElement = $Context.References[0]
                [List[ConsoleKeyInfo]]$KeysPressed = $Context.References[[SMState]::ContextKeysPressed]

                If($KeysPressed.Count -GT 0) {
                    Foreach($KeyPress in $KeysPressed) {
                        If($KeyPress.Key -EQ [ConsoleKey]::Backspace) {
                            If($SelfElement.InputBuffer.Length -GT 0) {
                                $SelfElement.InputBuffer = $SelfElement.InputBuffer.Substring(0, $SelfElement.InputBuffer.Length - 1)
                                $SelfElement.Dirty = $true
                            }
                        } ElseIf ($KeyPress.Key -NE [ConsoleKey]::Enter -AND $KeyPress.Key -NE [ConsoleKey]::Escape -AND $KeyPress.Key -NE [ConsoleKey]::Tab) {
                            If($SelfElement.InputBuffer.Length -LT $SelfElement.MaxCharacters) {
                                If(![char]::IsControl($KeyPress.KeyChar)) {
                                    $SelfElement.InputBuffer += $KeyPress.KeyChar
                                    $SelfElement.Dirty = $true
                                }
                            }
                        }
                    }
                }
            }
        })
    }

    [String]ToAnsiControlSequenceString() {
        $this.Prefix.Coordinates = [ATCoordinates]::new($this.DrawCoordinates)
        $this.SetUserData($this.InputBuffer.PadRight($this.MaxCharacters, '_'))

        Return "$(([UIBase]$this).ToAnsiControlSequenceString())"
    }
}
