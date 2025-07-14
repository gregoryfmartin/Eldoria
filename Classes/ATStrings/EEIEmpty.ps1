using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# EEI EMPTY
#
# A SYMBOLIC REPRESENTATION OF AN EMPTY ENEMY IMAGE.
#
###############################################################################

Class EEIEmpty : EnemyEntityImage {
    EEIEmpty() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}
