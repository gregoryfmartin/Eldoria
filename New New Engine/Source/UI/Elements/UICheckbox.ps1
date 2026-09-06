using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# UICHECKBOX
#
###############################################################################

Class UICheckbox : UIBase {
    Static [String]$UnicodeBoxUnchecked = "`u{2610}"
    Static [String]$UnicodeBoxChecked   = "`u{2611}"

    [UICheckboxState]$State
    [ATCoordinates]$DrawCoordinates

    UICheckbox() : base() {
        $this.State           = [UICheckboxState]::Unchecked
        $this.DrawCoordinates = [ATCoordinates]::new(1, 1)
        $this.Dirty           = $true
        $this.SetupStates()
    }

    UICheckbox(
        [String]$LabelText
    ) : base() {
        $this.Dirty           = $true
        $this.State           = [UICheckboxState]::Unchecked
        $this.DrawCoordinates = [ATCoordinates]::new(1, 1)
        $this.SetUserData($LabelText)
        $this.SetupStates()
    }

    UICheckbox(
        [String]$LabelText,
        [ATCoordinates]$DrawCoordinates
    ) : base() {
        $this.Dirty           = $true
        $this.State           = [UICheckboxState]::Unchecked
        $this.DrawCoordinates = $DrawCoordinates
        $this.SetUserData($LabelText)
        $this.SetupStates()
    }

    [Void]SetupStates() {
        $this.Subscribe(@{
            'SMUiElementInactive_OnEnter' = {
                Param(
                    [Context]$Context
                )

                [UICheckbox]$SelfElement = $Context.References[0]

                $SelfElement.Prefix.ForegroundColor = [ColorLibrary]::UICheckboxInactiveColor
                $SelfElement.Dirty                  = $true
            }
            'SMUiElementActive_OnEnter' = {
                Param(
                    [Context]$Context
                )

                [UICheckbox]$SelfElement = $Context.References[0]

                $SelfElement.Prefix.ForegroundColor = [ColorLibrary]::UICheckboxActive
                $SelfElement.Dirty                  = $true
            }
            'SMUiElementFocused_OnEnter' = {
                Param(
                    [Context]$Context
                )

                [UICheckbox]$SelfElement = $Context.References[0]

                $SelfElement.Prefix.Decorations = [ATDecoration]@{
                    Italic = $true
                }
                $SelfElement.Dirty = $true
            }
        })
    }

    [Void]ToggleCheckbox() {
        Switch($this.State) {
            ([UICheckboxState]::Unchecked) {
                $this.State = [UICheckboxState]::Checked

                Break
            }

            ([UICheckboxState]::Checked) {
                $this.State = [UICheckboxState]::Unchecked

                Break
            }

            Default {
                # DO NOTHING ATM
            }
        }

        $this.Dirty = $true
    }

    [String]ToAnsiControlSequenceString() {
        [ATStringComposite]$A = [ATStringComposite]::new()

        Switch($this.State) {
            ([UICheckboxState]::Unchecked) {
                $A.CompositeActual.Add(
                    [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = ($this.Behavior.Active -EQ $true) ? [ColorLibrary]::TextColor : [ColorLibrary]::UICheckboxInactiveColor
                            Coordinates     = $this.DrawCoordinates
                        }
                        UserData   = "$([UICheckbox]::UnicodeBoxUnchecked) "
                        UseATReset = $true
                    }
                )
                
                Break
            }

            ([UICheckboxState]::Checked) {
                $A.CompositeActual.Add(
                    [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = ($this.Behavior.Active -EQ $true) ? [ColorLibrary]::UICheckboxChecked : [ColorLibrary]::UICheckboxInactiveColor
                            Coordinates     = $this.DrawCoordinates
                        }
                        UserData   = "$([UICheckbox]::UnicodeBoxChecked) "
                        UseATReset = $true
                    }
                )

                Break
            }

            Default {
                $A.CompositeActual.Add(
                    [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = ($this.Behavior.Active -EQ $true) ? [ColorLibrary]::TextColor : [ColorLibrary]::UICheckboxInactiveColor
                            Coordinates     = $this.DrawCoordinates
                        }
                        UserData   = "$([UICheckbox]::UnicodeBoxUnchecked) "
                        UseATReset = $true
                    }
                )
                
                Break
            }
        }

        If($this.Behavior.Active -EQ $true) {
            If($this.Behavior.CanHaveFocus -EQ $true -AND $this.Behavior.HasFocus -EQ $true) {
                $A.CompositeActual.Add(
                    [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [ColorLibrary]::UICheckboxHasFocus
                        }
                        UserData   = "$($this.UserData)"
                        UseATReset = $true
                    }
                )
            } Else {
                $A.CompositeActual.Add(
                    [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [ColorLibrary]::TextColor
                        }
                        UserData   = "$($this.UserData)"
                        UseATReset = $true
                    }
                )
            }
        } Else {
            $A.CompositeActual.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [ColorLibrary]::UICheckboxInactiveColor
                    }
                    UserData   = "$($this.UserData)"
                    UseATReset = $true
                }
            )
        }

        Return "$($A.ToAnsiControlSequenceString())"
    }
}
