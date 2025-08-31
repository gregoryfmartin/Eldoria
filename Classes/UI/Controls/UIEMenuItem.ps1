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
        Return "$(([UIEBase]$this).ToAnsiControlSequenceString())"
    }
    
    [Void]SetUserData(
        [String]$UserData
    ) {
        ([UIEBase]$this).SetUserData("  $($UserData)")
    }

    [Void]ToggleSelected() {
        $this.Selected = -NOT $this.Selected
        $this.Update()
    }

    [Void]Update() {
        # $this.Prefix.ForegroundColor = ($this.Selected ? [CCListItemCurrentHighlight24]::new() : [CCTextDefault24]::new())
        
        [Char[]]$Temp = $this.UserData.ToCharArray()
        
        If($this.Selected -EQ $false) {
            $Temp[0] = ' '
            $this.Prefix.ForegroundColor = [CCTextDefault24]::new()
            $this.Prefix.Decorations = [ATDecorationNone]::new()
        } Else {
            $Temp[0] = "$([UIEMenuItem]::ChevronData)"
            $this.Prefix.ForegroundColor = [CCListItemCurrentHighlight24]::new()
            $this.Prefix.Decorations = [ATDecoration]@{ Blink = $true }
        }
        
        $this.UserData = [String]::new($Temp)
        
        $this.Dirty = $true
    }

    # THERE'S NO NEED TO OVERRIDE DRAW SINCE IT SHOULD WORK JUST FINE
}
