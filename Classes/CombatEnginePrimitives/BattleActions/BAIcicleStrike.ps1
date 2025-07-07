using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA ICICLE STRIKE
#
###############################################################################

Class BAIcicleStrike : BattleAction {
    BAIcicleStrike() : base() {
        $this.Name        = 'Icicle Strike'
        $this.Description = 'When they''re this big, who needs a sword?'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}
