using namespace System

Set-StrictMode -Version Latest

Class BAArcticFury : BattleAction {
    BAArcticFury() : base() {
        $this.Name        = 'Arctic Fury'
        $this.Description = 'An ass whooping is a dish best served cold.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}
