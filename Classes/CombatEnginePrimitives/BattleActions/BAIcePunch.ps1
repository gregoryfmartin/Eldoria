using namespace System

Set-StrictMode -Version Latest

Class BAIcePunch : BattleAction {
    BAIcePunch() : base() {
        $this.Name        = 'Ice Punch'
        $this.Description = 'Frigid AND stiff.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}
