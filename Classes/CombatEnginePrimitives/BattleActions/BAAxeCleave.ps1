using namespace System

Set-StrictMode -Version Latest

Class BAAxeCleave : BattleAction {
    BAAxeCleave() : base() {
        $this.Name        = 'Axe Cleave'
        $this.Description = 'Before his fury, the trees stood no chance.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 90
        $this.Chance      = 0.8
    }
}
