using namespace System

Set-StrictMode -Version Latest

Class BAAquaticBolt : BattleAction {
    BAAquaticBolt() : base() {
        $this.Name        = 'Aquatic Bolt'
        $this.Description = 'Some watery things to pelt your neighbor with.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}
