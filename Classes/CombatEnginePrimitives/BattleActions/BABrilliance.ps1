using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA BRILLIANCE
#
###############################################################################

Class BABrilliance : BattleAction { 
    BABrilliance() : base() {
        $this.Name        = 'Brilliance'
        $this.Description = 'How I feel when I look at myself in the mirror.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}
