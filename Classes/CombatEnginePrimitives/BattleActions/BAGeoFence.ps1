using namespace System

Set-StrictMode -Version Latest

Class BAGeoFence : BattleAction {
    BAGeoFence() : base() {
        $this.Name        = 'Geo Fence'
        $this.Description = 'Get off my lawn!'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.MpCost      = 400
        $this.EffectValue = 2000
        $this.Chance      = 0.1
    }
}
