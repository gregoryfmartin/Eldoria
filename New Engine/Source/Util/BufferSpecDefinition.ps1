using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# BUFFER SPEC DEFINTION
#
# INTS ARE BOUNDS.
#
###############################################################################

Class BufferSpecDefinition {
    [ClampableInt]$BufferMinWidth
    [ClampableInt]$BufferMinHeight

    BufferSpecDefinition() {
        $this.BufferMinWidth = [ClampableInt]::new(80, 80, 90)
        $this.BufferMinHeight = [ClampableInt]::new(50, 50, 60)
    }
}
