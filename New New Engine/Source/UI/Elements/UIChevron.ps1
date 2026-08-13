using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# UI CHEVRON
#
###############################################################################

Class UIChevron : UIBase {
    Static [String]$UnicodeChevronRight = "`u{276F}"
    Static [String]$UnicodeChevronLeft  = "`u{276E}"

    [UIChevronOrientation]$Orientation
    [ATCoordinates]$DrawCoordinates

    UIChevron() : base() {
        $this.Dirty           = $true
        $this.UseATReset      = $true
        $this.Orientation     = [UIChevronOrientation]::Left
        $this.DrawCoordinates = [ATCoordinates]::new(1, 1)
    }

    UIChevron(
        [UIChevronOrientation]$Orientation,
        [ATCoordinates]$DrawCoordinates
    ) : base() {
        $this.Dirty           = $true
        $this.UseATReset      = $true
        $this.Orientation     = $Orientation
        $this.DrawCoordinates = $DrawCoordinates

        # TEST CODE
        $this.Behavior.Active = $true
        # $this.Behavior.HasFocus = $true
    }

    [String]ToAnsiControlSequenceString() {
        $this.Prefix.Coordinates = [ATCoordinates]::new($this.DrawCoordinates)

        If($this.Behavior.Active -EQ $true) {
            If($this.Behavior.HasFocus -EQ $true) {
                $this.Prefix.ForegroundColor = [ColorLibrary]::UIChevronHasFocus
            } Else {
                $this.Prefix.ForegroundColor = [ColorLibrary]::UIChevronActive
            }
        } Else {
            $this.Prefix.ForegroundColor = [ColorLibrary]::UIChevronInactive
        }

        Switch($this.Orientation) {
            ([UIChevronOrientation]::Left) {
                $this.SetUserData("$([UIChevron]::UnicodeChevronLeft)")

                Break
            }

            ([UIChevronOrientation]::Right) {
                $this.SetUserData("$([UIChevron]::UnicodeChevronRight)")

                Break
            }

            Default {
                $this.SetUserData("$([UIChevron]::UnicodeChevronLeft)")

                Break
            }
        }

        Return "$(([UIBase]$this).ToAnsiControlSequenceString())"
    }
}
