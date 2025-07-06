using namespace System

Set-StrictMode -Version Latest

Class BATsunami : BattleAction {
    BATsunami() : base() {
        $this.Name        = 'Tsunami'
        $this.Description = 'WAVES!'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}
