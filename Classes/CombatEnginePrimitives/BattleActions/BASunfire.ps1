using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA SUNFIRE
#
###############################################################################

Class BASunfire : BattleAction {
    BASunfire() : base() {
        $this.Name        = 'Sunfire'
        $this.Description = 'Scorched Earth, mofo.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.MpCost      = 400
        $this.EffectValue = 2000
        $this.Chance      = 0.1
    }
}
