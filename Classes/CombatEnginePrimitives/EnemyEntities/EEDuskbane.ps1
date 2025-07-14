using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# EE DUSKBANE
#
###############################################################################

Class EEDuskbane : EEBat {
    EEDuskbane() : base() {
        $this.Name        = 'Duskbane'
        $this.Image       = $Script:EeiDuskbane
        $this.SpoilsItems = @()
    }
}
