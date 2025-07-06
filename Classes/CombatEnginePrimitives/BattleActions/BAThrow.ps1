using namespace System

Set-StrictMode -Version Latest

Class BAThrow : BattleAction {
    BAThrow() : base() {
        $this.Name        = 'Throw'
        $this.Description = 'One man''s trash is a useful weapon.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 0
        $this.Chance      = 0.9
    }
}
