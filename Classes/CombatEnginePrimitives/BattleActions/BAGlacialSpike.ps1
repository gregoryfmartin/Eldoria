using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA GLACIAL SPIKE
#
###############################################################################

Class BAGlacialSpike : BattleAction {
    BAGlacialSpike() : base() {
        $this.Name        = 'Glacial Spike'
        $this.Description = 'Global warming helped me make this one.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}
