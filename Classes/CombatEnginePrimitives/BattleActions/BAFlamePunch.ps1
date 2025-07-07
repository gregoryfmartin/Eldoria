using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA FLAME PUNCH
#
###############################################################################

Class BAFlamePunch : BattleAction {
    BAFlamePunch() : base() {
        $this.Name        = 'Flame Punch'
        $this.Description = 'Flaming fists of fury.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 5
        $this.EffectValue = 75
        $this.Chance      = 1.0
    }
}
