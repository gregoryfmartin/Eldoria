using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA FROZEN SPEAR
#
###############################################################################

Class BAFrozenSpear : BattleAction {
    BAFrozenSpear() : base() {
        $this.Name        = 'Frozen Spear'
        $this.Description = 'I found this spear in a fridge.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.MpCost      = 15
        $this.EffectValue = 100
        $this.Chance      = 1.0
    }
}
