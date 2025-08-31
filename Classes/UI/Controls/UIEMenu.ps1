using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# UIE MENU
#
# A LIST OF UIE MENU ITEMS.
#
###############################################################################

Class UIEMenu : List[UIEMenuItem] {
    [Int]$ActiveIndex
    
    UIEMenu(
        [Hashtable[]]$ListData,
        [ATCoordinates]$DrawOrigin
    ) : base() {
        # LISTDATA IS EXPECTED TO BE FORMATTED AS AN ARRAY OF HASHTABLES LIKE:
        # @(
        #   ${ LABEL = ''; ACTION = {} },
        #   ...
        # )
        $this.ActiveIndex = 0
        $this.InitializeMenuItems($ListData, $DrawOrigin)
    }
    
    [Void]InitializeMenuItems(
        [Hashtable[]]$ListData,
        [ATCoordinates]$DrawOrigin
    ) {
        For([Int]$A = 0; $A -LT $ListData.Count; $A++) {
            [ATCoordinates]$P = [ATCoordinates]@{
                Row    = $DrawOrigin.Row + $A + 1
                Column = $DrawOrigin.Column + 1
            }
            
            [UIEMenuItem]$I = [UIEMenuItem]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = $P
                }
                Action = $ListData[$A].Action
            }
            $I.SetUserData("$($ListData[$A].Label)")
            
            If($A -EQ 0) {
                $I.ToggleSelected()
            } Else {
                $I.Update()
            }
            
            $I.Dirty = $true
            $this.Add($I)
        }
    }
    
    [Void]Draw() {
        Foreach($I in $this) {
            $I.Draw()
        }
    }
    
    [Void]SetActiveColored() {
        $this[$this.ActiveIndex].Prefix.ForegroundColor = [CCListItemCurrentHighlight24]::new()
        $this[$this.ActiveIndex].Prefix.Decorations = [ATDecoration]@{ Blink = $true }
        $this[$this.ActiveIndex].Dirty = $true
    }
    
    [Void]UnsetActiveColored() {
        $this[$this.ActiveIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
        $this[$this.ActiveIndex].Prefix.Decorations = [ATDecorationNone]::new()
        $this[$this.ActiveIndex].Dirty = $true
    }
    
    [Void]PlayMoveSound() {
        Try {
            $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
            $Script:TheSfxMPlayer.Play()
        } Catch {}
    }
    
    [Void]MoveActiveIndexUp() {
        $this[$this.ActiveIndex].ToggleSelected()
        $this.ActiveIndex = ($this.ActiveIndex -EQ 0 ? $this.Count - 1 : $this.ActiveIndex - 1)
        $this[$this.ActiveIndex].ToggleSelected()
        $this.PlayMoveSound()
    }
    
    [Void]MoveActiveIndexDown() {
        $this[$this.ActiveIndex].ToggleSelected()
        $this.ActiveIndex = ($this.ActiveIndex -EQ $this.Count - 1 ? 0 : $this.ActiveIndex + 1)
        $this[$this.ActiveIndex].ToggleSelected()
        $this.PlayMoveSound()
    }
    
    [Void]InvokeItemAction() {
        & $this[$this.ActiveIndex].Action
    }
}
