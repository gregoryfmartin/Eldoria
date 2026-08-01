using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# AT STRING PREFIX
#
# AN AGGREGATE OF SEVERAL ANSI MODIFIERS THAT COLLECTIVELY MODIFY A PRECEEDING
# STRING LITERAL.
#
###############################################################################

Class ATStringPrefix {
    [ATForegroundColor24]$ForegroundColor
    [ATBackgroundColor24]$BackgroundColor
    [ATDecoration]$Decorations
    [ATCoordinates]$Coordinates

    ATStringPrefix() {
        $this.ForegroundColor = [ATForegroundColor24None]::new()
        $this.BackgroundColor = [ATBackgroundColor24None]::new()
        $this.Decorations     = [ATDecorationNone]::new()
        $this.Coordinates     = [ATCoordinatesNone]::new()
    }

    ATStringPrefix(
        [ATForegroundColor24]$ForegroundColor,
        [ATBackgroundColor24]$BackgroundColor,
        [ATDecoration]$Decorations,
        [ATCoordinates]$Coordinates
    ) {
        $this.ForegroundColor = $ForegroundColor
        $this.BackgroundColor = $BackgroundColor
        $this.Decorations     = $Decorations
        $this.Coordinates     = $Coordinates
    }

    [String]ToAnsiControlSequenceString() {
        Return "$($this.Coordinates.ToAnsiControlSequenceString())$($this.Decorations.ToAnsiControlSequenceString())$($this.ForegroundColor.ToAnsiControlSequenceString())$($this.BackgroundColor.ToAnsiControlSequenceString())"
    }
}
