using namespace System

Set-StrictMode -Version Latest

Class BAIceBolt : BattleAction {
    BAIceBolt() : base() {
        $this.Name        = 'Ice Bolt'
        $this.Description = 'Not the kind of bolt you secure things with.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}
