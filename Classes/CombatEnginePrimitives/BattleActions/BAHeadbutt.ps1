using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA HEADBUTT
#
###############################################################################

Class BAHeadbutt : BattleAction {
    BAHeadbutt() : base() {
        $this.Name        = 'Headbutt'
        $this.Description = 'Put that noggin'' to work!'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 160
        $this.Chance      = 0.4
    }
}
