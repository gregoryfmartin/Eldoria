using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# AT STRING NONE
#
# AN ABSTRACTION OF AT STRING INTENDED TO IMPLY NO AT STRING BE USED. THIS
# CLASS IS GENERALLY USED AS A SANE DEFAULT INITIALIZATION POINT FOR WHAT WOULD
# EVENTUALLY BE PROPER AT STRING INSTANCES.
#
# INHERITS:
#   ATSTRING
#
###############################################################################

Class ATStringNone : ATString {
    ATStringNone() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}
