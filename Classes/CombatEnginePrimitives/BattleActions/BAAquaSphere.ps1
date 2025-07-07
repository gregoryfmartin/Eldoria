using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA AQUA SPHERE
#
###############################################################################

Class BAAquaSphere : BattleAction {
    BAAquaSphere() : base() {
        $this.Name        = 'Aqua Sphere'
        $this.Description = 'Listen to ''Barbie Girl'' all day long. Enjoy.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}
