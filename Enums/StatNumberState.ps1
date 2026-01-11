using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# STAT NUMBER STATE
#
# NORMAL
#    THE NUMBER IS WITHIN NORMAL TOLERANCES.
#
# CAUTION
#    THE NUMBER IS BELOW NORMAL BUT ABOVE CRITICAL TOLERANCES.
#
# DANGER
#    THE NUMBER IS BELOW CRITICAL TOLERANCES.
#
# NOTE THAT THIS ENUMERATION MAKE NO OPINION ON WHAT DEFINES SAID TOLERANCES.
# THIS IS LEFT TO THE IMPLEMENTATION.
#
###############################################################################

Enum StatNumberState {
    Normal
    Caution
    Danger
}
