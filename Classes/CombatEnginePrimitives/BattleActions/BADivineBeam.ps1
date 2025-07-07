using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA DIVINE BEAM
#
###############################################################################

Class BADivineBeam : BattleAction {
    BADivineBeam() : base() {
        $this.Name        = 'Divine Beam'
        $this.Description = 'Got Jesus?'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}
