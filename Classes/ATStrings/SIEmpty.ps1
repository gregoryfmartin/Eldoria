using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI EMPTY
#
###############################################################################

Class SIEmpty : SceneImage {
    SIEmpty() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}
