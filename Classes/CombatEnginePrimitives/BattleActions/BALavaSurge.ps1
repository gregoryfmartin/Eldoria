using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA LAVA SURGE
#
###############################################################################

Class BALavaSurge : BattleAction {
    BALavaSurge() : base() {
        $this.Name        = 'Lava Surge'
        $this.Description = 'It''s like a surge of love, only the molten kind.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 15
        $this.EffectValue = 100
        $this.Chance      = 1.0
    }
}
