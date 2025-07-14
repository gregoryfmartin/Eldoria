using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA KARATE CHOP
#
###############################################################################

Class BAKarateChop : BattleAction {
    BAKarateChop() : base() {
        $this.Name        = 'Karate Chop'
        $this.Description = 'Test your might!'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 60
        $this.Chance      = 0.8
    }
}
