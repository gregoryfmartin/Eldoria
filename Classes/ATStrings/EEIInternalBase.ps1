using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# EEI INTERNAL BASE
#
# AN EXPRESSION OF THE ENEMY ENTITY IMAGE THAT ADDS A COLOR MAP. THIS IS THE
# BASE FOR PRACTICAL APPLICATIONS.
#
###############################################################################

Class EEIInternalBase : EnemyEntityImage {
    [ATBackgroundColor24[]]$ColorMap

    EEIInternalBase() : base() {
        # THESE LITERALS WERE POLLED FROM THE SCENE IMAGE CLASS, ALTHOUGH I'M PRETTY SURE THESE ARE WRONG
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]48) * ([Int32]18)))
    }
}
