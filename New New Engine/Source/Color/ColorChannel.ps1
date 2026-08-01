using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# COLOR CHANNEL
#
# SHORTHAND FOR A CLAMPABLE INT USED IN COLOR CHANNELS.
#
###############################################################################

Class ColorChannel : ClampableInt {
    ColorChannel() : base(0, 0, 255) {}

    ColorChannel(
        [Int]$Value
    ) : base($Value, 0, 255) {}
}
