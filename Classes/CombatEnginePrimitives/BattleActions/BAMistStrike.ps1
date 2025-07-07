using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA MIST STRIKE
#
###############################################################################

Class BAMistStrike : BattleAction {
    BAMistStrike() : base() {
        $this.Name        = 'Mist Strike'
        $this.Description = 'Was it a cat I saw? Was I tac a ti saw?'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 15
        $this.EffectValue = 100
        $this.Chance      = 1.0
    }
}
