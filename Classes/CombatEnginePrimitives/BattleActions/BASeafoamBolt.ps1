using namespace System

Set-StrictMode -Version Latest

Class BASeafoamBolt : BattleAction {
    BASeafoamBolt() : base() {
        $this.Name        = 'Seafoam Bolt'
        $this.Description = 'Sometimes I see these white bubbles on the shore.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}
