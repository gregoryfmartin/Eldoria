using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA TYPHOON
#
###############################################################################

Class BATyphoon : BattleAction {
    BATyphoon() : base() {
        $this.Name        = 'Typhoon'
        $this.Description = 'Not to be confused with the infamous Tie Foon.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}
