using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# UIEMENUITEM
#
# A MENU ITEM THAT OFFERS A SELECTABLE ACTION.
#
###############################################################################

Class UIEMenuItem : UIEBase {
    Static [String]$ChevronData = '❱'

    [Boolean]$Selected
    [ScriptBlock]$Action

    UIEMenuItem() : base() {
        $this.Selected = $false
        $this.Action   = {}
    }

    [String]ToAnsiControlSequenceString() {
        $this.Prefix.ForegroundColor = ($this.Selected ? [CCAppleVGreenLight24]::new() : [CCAppleVGreyDark24]::new())
        $this.SetUserData(($this.Selected ? "$([UIEMenuItem]::ChevronData) $($this.UserData)" : "$($this.UserData)"))

        Return "$(([UIEBase]$this).ToAnsiControlSequenceString())"
    }

    # THERE'S NO NEED TO OVERRIDE DRAW SINCE IT SHOULD WORK JUST FINE
}
