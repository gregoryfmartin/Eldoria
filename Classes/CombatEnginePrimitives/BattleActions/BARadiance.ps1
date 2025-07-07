using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA RADIANCE
#
###############################################################################

Class BARadiance : BattleAction {
    BARadiance() : base() {
        $this.Name        = 'Radiance'
        $this.Description = 'All teh brights.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}
