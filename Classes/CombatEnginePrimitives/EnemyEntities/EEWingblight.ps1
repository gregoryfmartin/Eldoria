using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# EE WINGBLIGHT
#
###############################################################################

Class EEWingblight : EEBat {
    EEWingblight() : base() {
        $this.Name        = 'Wingblight'
        $this.Image       = $Script:EeiWingblight
        $this.SpoilsItems = @()
    }
}
