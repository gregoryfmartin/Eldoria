using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# EE NIGHTWING
#
###############################################################################

Class EENightwing : EEBat {
    EENightwing() : base() {
        $this.Name  = 'Nightwing'
        $this.Image = [EEINightwing]::new()
    }
}
