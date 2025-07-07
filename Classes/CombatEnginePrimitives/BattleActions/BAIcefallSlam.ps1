using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA ICEFALL SLAM
#
###############################################################################

Class BAIcefallSlam : BattleAction {
    BAIcefallSlam() : base() {
        $this.Name        = 'Icefall Slam'
        $this.Description = 'Not avoiding the avalanche is a bad idea.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.MpCost      = 15
        $this.EffectValue = 100
        $this.Chance      = 1.0
    }
}
