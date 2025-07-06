using namespace System

Set-StrictMode -Version Latest

Class BABlazeBurst : BattleAction {
    BABlazeBurst() : base() {
        $this.Name        = 'Blaze Burst'
        $this.Description = 'Like an arc flash, only worse.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 10
        $this.EffectValue = 80
        $this.Chance      = 0.8
    }
}
