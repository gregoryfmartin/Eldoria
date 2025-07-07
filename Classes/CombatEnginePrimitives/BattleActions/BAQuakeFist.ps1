using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA QUAKE FIST
#
###############################################################################

Class BAQuakeFist : BattleAction {
    BAQuakeFist() : base() {
        $this.Name        = 'Quake Fist'
        $this.Description = 'Two nerds get in a fight at QuakeCon.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}
