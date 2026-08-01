using namespace System
using namespace System.Management.Automation.Host

Set-StrictMode -Version Latest





###############################################################################
#
# AT COORDINATES
#
# A SYMBOLIC ENCAPSULATION OF A COORDINATE PAIR IN ROW,COLUMN (Y,X) ORDER.
#
###############################################################################

Class ATCoordinates {
    [ClampableInt]$Row
    [ClampableInt]$Column

    ATCoordinates() {
        $this.Row    = [ClampableInt]::new(1, 1, 40)
        $this.Column = [ClampableInt]::new(1, 1, 80)
    }

    ATCoordinates(
        [Int]$Row,
        [Int]$Column
    ) {
        $this.Row    = [ClampableInt]::new($Row, 1, 40)
        $this.Column = [ClampableInt]::new($Column, 1, 80)
    }

    ATCoordinates(
        [Coordinates]$AutomationCoordinates
    ) {
        $this.Row = [ClampableInt]::new($AutomationCoordinates.Y, 1, 40)
        $this.Column = [ClampableInt]::new($AutomationCoordinates.X, 1, 80)
    }

    ATCoordinates(
        [ATCoordinates]$CopyFrom
    ) {
        $this.Row    = $CopyFrom.Row
        $this.Column = $CopyFrom.Column
    }

    [String]ToAnsiControlSequenceString() {
        Return "$([ATControlSequences]::GenerateCoordinateString($this.Row, $this.Column))"
    }

    [Coordinates]ToAutomationCoordinates() {
        Return [Coordinates]::new($this.Column, $this.Row)
    }
}
