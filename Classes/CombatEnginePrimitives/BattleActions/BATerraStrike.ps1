using namespace System

Set-StrictMode -Version Latest

Class BATerraStrike : BattleAction {
    BATerraStrike() : base() {
        $this.Name        = 'Terra Strike'
        $this.Description = 'Sticks and stones can break your bones.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}
