using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# EE DARKFANG
#
###############################################################################

Class EEDarkfang : EEBat {
    EEDarkfang() : base() {
        $this.Name        = 'Darkfang'
        $this.Image       = $Script:EeiDarkfang
        $this.SpoilsItems = @()
    }
}
