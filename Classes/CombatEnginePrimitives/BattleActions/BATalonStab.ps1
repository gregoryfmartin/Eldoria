using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA TALON STAB
#
###############################################################################

Class BATalonStab : BattleAction {
    BATalonStab() : base() {
        $this.Name        = 'Talon Stab'
        $this.Description = 'You don''t want a hug from these.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 70
        $this.Chance      = 1.0
    }
}
