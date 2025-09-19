using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# UIECEVRON
#
# A SINGLE CHEVRON CHARACTER. MEANT TO BE USED IN A COLLECTION.
#
###############################################################################

Class UIEChevron : UIEBase {
    Static [String]$ChevronCharacter = '❱'
    
    UIEChevron() : base() {
        $this.UserData = "$([UIEChevron]::ChevronCharacter)"
        $this.Blank    = ' '
    }
}
