using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# EE NOCTURNA
#
###############################################################################

Class EENocturna : EEBat {
    EENocturna() : base() {
        $this.Name        = 'Nocturna'
        $this.Image       = $Script:EeiNocturna
        $this.SpoilsItems = @()
    }
}
