using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA THUNDER CLAP
#
###############################################################################

Class BAThunderClap : BattleAction {
    BAThunderClap() : base() {
        $this.Name        = 'Thunder Clap'
        $this.Description = 'Sometimes an euphemism, this time a threat.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}
