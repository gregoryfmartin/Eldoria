using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA LIGHTBRINGER
#
###############################################################################

Class BALightbringer : BattleAction {
    BALightbringer() : base() {
        $this.Name        = 'Lightbringer'
        $this.Description = 'Bring the party!'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}
