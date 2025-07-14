using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA ANGELIC HYMN
#
###############################################################################

Class BAAngelicHymn : BattleAction {
    BAAngelicHymn() : base() {
        $this.Name        = 'Angelic Hymn'
        $this.Description = 'This is how I sound when I sing Britney Spears.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}
