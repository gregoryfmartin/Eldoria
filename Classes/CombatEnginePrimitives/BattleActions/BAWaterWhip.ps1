using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA WATER WHIP
#
###############################################################################

Class BAWaterWhip : BattleAction {
    BAWaterWhip() : base() {
        $this.Name        = 'Water Whip'
        $this.Description = 'Indiana Jones''s least favorite whip.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}
