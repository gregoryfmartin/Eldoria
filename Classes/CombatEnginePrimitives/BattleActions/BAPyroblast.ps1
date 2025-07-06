using namespace System

Set-StrictMode -Version Latest

Class BAPyroblast : BattleAction {
    BAPyroblast() : base() {
        $this.Name        = 'Pyroblast'
        $this.Description = 'Fireworks never looked so good.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 15
        $this.EffectValue = 110
        $this.Chance      = 0.6
    }
}
