using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA GALE STRIKE
#
###############################################################################

Class BAGaleStrike : BattleAction {
    BAGaleStrike() : base() {
        $this.Name        = 'Gale Strike'
        $this.Description = 'The wind can hurt you.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}
