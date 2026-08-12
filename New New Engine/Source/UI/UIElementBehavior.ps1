using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# UI ELEMENT BEHAVIOR
#
# ENCAPSULATES COMMON BEHAVIOR FOR UI ELEMENTS.
#
# CAN HAVE FOCUS
#   FLAG INDICATING THAT THIS ELEMENT CAN BE FOCUSED ON, IN OTHER WORDS, CAN
#   THIS ELEMENT RECEIVE INPUT.
#
# HAS FOCUS
#   FLAG INDICATING THAT THIS ELEMENT CURRENTLY HAS FOCUS, IN OTHER WORDS,
#   IT'S CURRENTLY PROCESSING INPUT.
#
# ACTIVE
#   FLAG INDICATING THAT THIS ELEMENT IS ACTIVE OR NOT, IN OTHER WORDS,
#   IS ANY PROCESSING APPLIED TO THE ELEMENT? THIS CAN ALSO IMPLY
#   VISUAL CUES, BUT IS AT THE DISCRETION OF THE NEEDS OF THE SCENE.
#
# GROUP IDENTIFIER
#   SPECIFIES A "GROUP" THE ELEMENT BELONGS TO. THIS REALLY ONLY HAS MEANING
#   FOR RADIO BUTTONS.
#
###############################################################################

Class UIElementBehavior {
    [Boolean]$CanHaveFocus
    [Boolean]$HasFocus
    [Boolean]$Active
    [String]$GroupIdentifier

    UIElementBehavior() {
        $this.CanHaveFocus    = $false
        $this.HasFocus        = $false
        $this.Active          = $false
        $this.GroupIdentifier = ''
    }
}
