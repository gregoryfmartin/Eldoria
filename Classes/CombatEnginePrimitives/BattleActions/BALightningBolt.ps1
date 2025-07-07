using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA LIGHTNING BOLT
#
###############################################################################

Class BALightningBolt : BattleAction {
    BALightningBolt() : base() {
        $this.Name        = 'Lightning Bolt'
        $this.Description = 'These look cool from a distance.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}
