using namespace System

Set-StrictMode -Version Latest

Class BAMortarToss : BattleAction {
    BAMortarToss() : base() {
        $this.Name        = 'Mortar Toss'
        $this.Description = 'An esploozshun of firez.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 9
        $this.EffectValue = 100
        $this.Chance      = 0.7
    }
}
