using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA BASH
#
###############################################################################

Class BAKarateKick : BattleAction {
    BAKarateKick() : base() {
        $this.Name        = 'Karate Kick'
        $this.Description = 'I hope your shins are fit.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 65
        $this.Chance      = 0.75
    }
}
