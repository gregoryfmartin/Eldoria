using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA PRISM SHOCK
#
###############################################################################

Class BAPrismShock : BattleAction {
    BAPrismShock() : base() {
        $this.Name        = 'Prism Shock'
        $this.Description = 'The pretty rainbow of death.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}
