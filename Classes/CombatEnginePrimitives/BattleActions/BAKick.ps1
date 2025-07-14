using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA KICK
#
###############################################################################

Class BAKick : BattleAction {
    BAKick() : base() {
        $this.Name        = 'Kick'
        $this.Description = 'A kick. Don''t stub your toe.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 50
        $this.Chance      = 1.0
    }
}
