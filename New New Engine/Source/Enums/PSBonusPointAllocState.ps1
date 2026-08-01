using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# PS BONUS POINT ALLOC STATE
#
# THE STATES THAT THE PS BONUS POINT ALLOC WINDOW GOES THROUGH.
#
# NOTE: THIS GOES AWAY WITH THE STATE MACHINE IMPLEMENTATION.
#
###############################################################################

Enum PSBonusPointAllocState {
    AtkPointsMod
    DefPointsMod
    MatPointsMod
    MdfPointsMod
    SpdPointsMod
    AccPointsMod
    LckPointsMod
}
