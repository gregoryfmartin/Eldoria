using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA WIND CATACLYSM
#
###############################################################################

Class BAWindCataclysm : BattleAction {
    BAWindCataclysm() : base() {
        $this.Name        = "`u{03C6} Cataclysm"
        $this.Description = 'Windy death rains down upon you.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}
