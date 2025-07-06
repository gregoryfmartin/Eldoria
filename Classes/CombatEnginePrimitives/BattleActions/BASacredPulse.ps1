using namespace System

Set-StrictMode -Version Latest

Class BASacredPulse : BattleAction {
    BASacredPulse() : base() {
        $this.Name        = 'Sacred Pulse'
        $this.Description = 'The defunct newsletter of the Catholic Church.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}
