using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA ICE CATACLYSM
#
###############################################################################

Class BAIceCataclysm : BattleAction {
    BAIceCataclysm() : base() {
        $this.Name        = "`u{03C8} Cataclysm"
        $this.Description = 'Icy death rains down upon you.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}
