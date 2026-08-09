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
        $this.State = [UICheckboxState]::Unchecked
        $this.Dirty = $true
    }

    UICheckbox(
        [String]$LabelText
    ) : base() {
        $this.Dirty = $true
        $this.State = [UICheckboxState]::Unchecked
        $this.SetUserData($LabelText)
    }

    UICheckbox(
        [String]$LabelText,
        [ATCoordinates]$DrawCoordinates
    ) : base() {
        $this.Dirty           = $true
        $this.State           = [UICheckboxState]::Unchecked
        $this.DrawCoordinates = $DrawCoordinates
        $this.SetUserData($LabelText)
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
                            ForegroundColor = [ColorLibrary]::TextColor
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
                            ForegroundColor = [ColorLibrary]::UICheckboxChecked
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
                            ForegroundColor = [ColorLibrary]::TextColor
                            Coordinates     = $this.DrawCoordinates
                        }
                        UserData   = "$([UICheckbox]::UnicodeBoxUnchecked) "
                        UseATReset = $true
                    }
                )
                
                Break
            }
        }

        If($this.CanHaveFocus -EQ $true -AND $this.HasFocus -EQ $true) {
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

        Return "$($A.ToAnsiControlSequenceString())"
    }
}
