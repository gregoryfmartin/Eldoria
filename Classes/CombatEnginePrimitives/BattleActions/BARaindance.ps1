using namespace System

Set-StrictMode -Version Latest

Class BARaindance : BattleAction {
    BARaindance() : base() {
        $this.Name        = 'Raindance'
        $this.Description = 'Like Riverdance, only shit.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}
