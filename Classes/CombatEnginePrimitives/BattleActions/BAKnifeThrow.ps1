using namespace System

Set-StrictMode -Version Latest

Class BAKnifeThrow : BattleAction {
    BAKnifeThrow() : base() {
        $this.Name        = 'Knife Throw'
        $this.Description = 'Like throwing darts, but cooler.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 80
        $this.Chance      = 0.3
    }
}
