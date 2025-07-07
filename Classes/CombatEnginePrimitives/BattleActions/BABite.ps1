using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA BITE
#
###############################################################################

Class BABite : BattleAction {
    BABite() : base() {
        $this.Name        = 'Bite'
        $this.Description = 'When fists fail, teeth do just fine.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 40
        $this.Chance      = 0.9
    }
}
