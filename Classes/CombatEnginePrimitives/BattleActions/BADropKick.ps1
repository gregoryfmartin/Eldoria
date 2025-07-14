using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA DROP KICK
#
###############################################################################

Class BADropKick : BattleAction {
    BADropKick() : base() {
        $this.Name        = 'Dropkick'
        $this.Description = 'Don''t use this on Murphy.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 120
        $this.Chance      = 0.3
    }
}
