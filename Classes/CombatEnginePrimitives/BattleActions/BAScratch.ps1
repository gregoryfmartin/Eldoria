using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA SCRATCH
#
###############################################################################

Class BAScratch : BattleAction {
    BAScratch() : base() {
        $this.Name        = 'Scratch'
        $this.Description = 'Nails are sometimes useful.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 45
        $this.Chance      = 1.0
    }
}
