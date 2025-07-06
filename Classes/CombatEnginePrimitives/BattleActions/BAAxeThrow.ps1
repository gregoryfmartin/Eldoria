using namespace System

Set-StrictMode -Version Latest

Class BAAxeThrow : BattleAction {
    BAAxeThrow() : base() {
        $this.Name        = 'Axe Throw'
        $this.Description = 'Don''t let one hit you on the way out.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 180
        $this.Chance      = 0.3
    }
}
