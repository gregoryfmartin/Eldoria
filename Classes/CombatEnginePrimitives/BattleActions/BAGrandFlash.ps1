using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA GRAND FLASH
#
###############################################################################

Class BAGrandFlash : BattleAction {
    BAGrandFlash() : base() {
        $this.Name        = 'Grand Flash'
        $this.Description = 'Right when the lightning strikes.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}
