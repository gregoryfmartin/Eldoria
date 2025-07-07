using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA TIDAL CRUSH
#
###############################################################################

Class BATidalCrush : BattleAction {
    BATidalCrush() : base() {
        $this.Name        = 'Tidal Crush'
        $this.Description = 'Your high school crush came to kill you, in water form.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}
