using namespace System

Set-StrictMode -Version Latest

Class BAAquaJet : BattleAction {
    BAAquaJet() : base() {
        $this.Name        = 'Aqua Jet'
        $this.Description = 'A Boeing 737 made entirely of water.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}
