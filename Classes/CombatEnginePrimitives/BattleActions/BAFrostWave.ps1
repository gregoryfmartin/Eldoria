using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA FROST WAVE
#
###############################################################################

Class BAFrostWave : BattleAction {
    BAFrostWave() : base() {
        $this.Name        = 'Frost Wave'
        $this.Description = 'Ride the wave, dude.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.MpCost      = 15
        $this.EffectValue = 100
        $this.Chance      = 1.0
    }
}
