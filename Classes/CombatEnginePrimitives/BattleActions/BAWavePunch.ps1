using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA WAVE PUNCH
#
###############################################################################

Class BAWavePunch : BattleAction {
    BAWavePunch() : base() {
        $this.Name        = 'Wave Punch'
        $this.Description = 'The latest Hawaiian Punch flavor. Swelling aftertaste.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 15
        $this.EffectValue = 100
        $this.Chance      = 1.0
    }
}
