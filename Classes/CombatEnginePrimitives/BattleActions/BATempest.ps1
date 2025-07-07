using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA TEMPEST
#
###############################################################################

Class BATempest : BattleAction {
    BATempest() : base() {
        $this.Name        = 'Tempest'
        $this.Description = 'If it were a tempest of love, would you feel any different?'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 400
        $this.EffectValue = 2000
        $this.Chance      = 0.1
    }
}
