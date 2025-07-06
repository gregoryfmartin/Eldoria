using namespace System

Set-StrictMode -Version Latest

Class BACyclone : BattleAction {
    BACyclone() : base() {
        $this.Name        = 'Cyclone'
        $this.Description = 'Something about moving all night long.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}
