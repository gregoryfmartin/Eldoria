using namespace System

Set-StrictMode -Version Latest

Class BADoubleScratch : BattleAction {
    BADoubleScratch() : base() {
        $this.Name        = 'Double Scratch'
        $this.Description = 'The manicure on these is lethal.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 85
        $this.Chance      = 0.75
    }
}
