using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA FLAMETHROWER
#
###############################################################################

Class BAFlamethrower : BattleAction {
    BAFlamethrower() : base() {
        $this.Name        = 'Flamethrower'
        $this.Description = 'Our inspiration was Elon.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 10
        $this.EffectValue = 90
        $this.Chance      = 0.7
    }
}
