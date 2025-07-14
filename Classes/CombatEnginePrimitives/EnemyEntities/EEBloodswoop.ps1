using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# EE BLOODSWOOP
#
###############################################################################

Class EEBloodswoop : EEBat {
    EEBloodswoop() : base() {
        $this.Name  = 'Bloodswoop'
        $this.Image = $Script:EeiBloodswoop
    }
}
