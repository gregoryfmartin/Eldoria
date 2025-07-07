using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA SWORD STAB
#
###############################################################################

Class BASwordStab : BattleAction {
    BASwordStab() : base() {
        $this.Name        = 'Sword Stab'
        $this.Description = 'This was practiced with toothpicks.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 80
        $this.Chance      = 0.7
    }
}
