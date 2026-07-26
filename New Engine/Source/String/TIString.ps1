using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# TI STRING
#
# AGAIN, I DON'T FUCKING REMEMBER WHAT TI MEANS. I WROTE IT A YEAR AGO, AND I
# FORGOT, EVEN WITH NOTES. I'M DUMB. IT'S INTENDED TO HOLD MULTIPLE FORMATS
# FOR A SINGLE IMAGE IN ONE OF THE MODES DEFINED IN THE TI STRING MODE ENUM.
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
