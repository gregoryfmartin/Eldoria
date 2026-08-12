using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# UI STATE
#
# THIS IS A STATE THAT MANAGES A COLLECTION OF UI ELEMENTS. THIS MAY END
# UP BEING A PROLIFIC STATE, BUT IT'S EASIER ON THE BRAIN.
#
# THE HASHTABLE COMPOSITION IS INT : UIBASE.
#
###############################################################################

Class UIState : SMState {
    [Int]$ActiveIndex
    [Hashtable]$UiElementListing

    UIState(
        [String]$StateName
    ) : base($StateName) {
        $this.ActiveIndex      = 0
        $this.UiElementListing = @{}
    }
}
