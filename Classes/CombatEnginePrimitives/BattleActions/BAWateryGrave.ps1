using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA WATERY GRAVE
#
###############################################################################

Class BAWateryGrave : BattleAction {
    BAWateryGrave() : base() {
        $this.Name        = 'Watery Grave'
        $this.Description = 'Davey Jones is holed up here.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}
