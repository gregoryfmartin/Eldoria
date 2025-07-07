using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA SKYWARD CUT
#
###############################################################################

Class BASkywardCut : BattleAction {
    BASkywardCut() : base() {
        $this.Name        = 'Skyward Cut'
        $this.Description = 'Remember to always cut away from yourself.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}
