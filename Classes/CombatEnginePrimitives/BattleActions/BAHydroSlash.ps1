using namespace System

Set-StrictMode -Version Latest

Class BAHydroSlash : BattleAction {
    BAHydroSlash() : base() {
        $this.Name        = 'Hydro Slash'
        $this.Description = 'A moistened bint lobbed this scimitar at me.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 15
        $this.EffectValue = 100
        $this.Chance      = 1.0
    }
}
