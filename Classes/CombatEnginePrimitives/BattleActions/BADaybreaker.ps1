using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA DAYBREAKER
#
###############################################################################

Class BADaybreaker : BattleAction {
    BADaybreaker() : base() {
        $this.Name        = 'Daybreaker'
        $this.Description = 'Some statue in Skyrim gave me this.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}
