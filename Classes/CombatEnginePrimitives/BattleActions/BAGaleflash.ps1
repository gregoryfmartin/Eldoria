using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA GALEFLASH
#
###############################################################################

Class BAGaleflash : BattleAction {
    BAGaleflash() : base() {
        $this.Name        = 'Galeflash'
        $this.Description = 'The lightning rode on the wind.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}
