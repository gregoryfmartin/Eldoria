using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA WATER CATACLYSM
#
###############################################################################

Class BAWaterCataclysm : BattleAction {
    BAWaterCataclysm() : base() {
        $this.Name        = "`u{03C8} Cataclysm"
        $this.Description = 'Watery death rains down upon you.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 400
        $this.EffectValue = 2000
        $this.Chance      = 0.1
    }
}
