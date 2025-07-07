using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MTO WARPABLE
#
###############################################################################

Class MTOWarpable : MapTileObject {
    [Ref]$WarpToReference
    [Int]$WarpToX
    [Int]$WarpToY

    MTOWarpable() {
        $this.WarpToReference = $null
        $this.WarpToX         = 0
        $this.WarpToY         = 0
        $this.Effect          = $Script:MapWarpHandler
    }
}
