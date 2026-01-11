using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# TTY SPEED
#
# FRAME-RATE UNBOUND TIMEOUTS FOR PER-CHARACTER RENDERING. THESE HAVE BEEN TESTED
# ON A GOOD NUMBER OF NON-QUANTUM COMPUTERS SO THIS SHOULD BE SAFE... I HOPE.
#
###############################################################################

Enum TtySpeed {
    SuperSlow = 1000000
    Slow      = 750000
    Normal    = 100000
    Moderate  = 75000
    Quick     = 65000
    Fast      = 50000
    SuperFast = 25000
}
