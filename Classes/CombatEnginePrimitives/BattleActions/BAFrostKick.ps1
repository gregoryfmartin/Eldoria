using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA FROST KICK
#
###############################################################################

Class BAFrostKick : BattleAction {
    BAFrostKick() : base() {
        $this.Name        = 'Frost Kick'
        $this.Description = 'Ice on the knee. It''s a thing.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}
