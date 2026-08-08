using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# TI STRING
#
###############################################################################

Class TIString {
    [String[]]$Variants

    TIString() {
        $this.Variants = @()
    }

    TIString(
        [String[]]$Variants
    ) {
        $this.Variants = $Variants
    }

    [String]GetModeVariant(
        [TIStringMode]$Mode
    ) {
        Return "$($this.Variants[([Int]$Mode)])"
    }
}
