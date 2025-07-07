using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA LEAF SHIELD
#
###############################################################################

Class BALeafShield : BattleAction {
    BALeafShield() : base() {
        $this.Name        = 'Leaf Shield'
        $this.Description = 'Are you sure this''ll work?'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}
