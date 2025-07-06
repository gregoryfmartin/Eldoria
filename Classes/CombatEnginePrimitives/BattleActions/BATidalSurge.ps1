using namespace System

Set-StrictMode -Version Latest

Class BATidalSurge : BattleAction {
    BATidalSurge() : base() {
        $this.Name        = 'Tidal Surge'
        $this.Description = 'They ebb, they flow, they attac.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}
