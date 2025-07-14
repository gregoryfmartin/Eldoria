using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA FIRE CATACLYSM
#
###############################################################################

Class BAFireCataclysm : BattleAction {
    BAFireCataclysm() : base() {
        $this.Name        = "`u{03B6} Cataclysm"
        $this.Description = 'Firey death rains upon you.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}
