using namespace System

Set-StrictMode -Version Latest

Class BAEmberSlash : BattleAction {
    BAEmberSlash() : base() {
        $this.Name        = 'Ember Slash'
        $this.Description = 'At least the wound is cauterized.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}
