using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA ASHEN NOVA
#
###############################################################################

Class BAAshenNova : BattleAction {
    BAAshenNova() : base() {
        $this.Name        = 'Ashen Nova'
        $this.Description = 'Reminds me of Pompeii. Only worse.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}
