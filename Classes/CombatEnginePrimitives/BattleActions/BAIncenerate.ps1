using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA INCENERATE
#
###############################################################################

Class BAIncenerate : BattleAction {
    BAIncenerate() : base() {
        $this.Name        = 'Incenerate'
        $this.Description = 'Kill it with fire, they said.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 20
        $this.EffectValue = 120
        $this.Chance      = 0.7
    }
}
