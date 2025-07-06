using namespace System

Set-StrictMode -Version Latest

Class BACinderStorm : BattleAction {
    BACinderStorm() : base() {
        $this.Name        = 'Cinder Storm'
        $this.Description = 'Hot coal hail. Yum.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 5
        $this.EffectValue = 60
        $this.Chance      = 0.9
    }
}
