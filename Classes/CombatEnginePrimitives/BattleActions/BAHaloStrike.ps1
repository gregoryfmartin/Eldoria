using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA HALO STRIKE
#
###############################################################################

Class BAHaloStrike : BattleAction {
    BAHaloStrike() : base() {
        $this.Name        = 'Halo Strike'
        $this.Description = 'These surprisingly hurt.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}
