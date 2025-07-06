using namespace System

Set-StrictMode -Version Latest

Class BAHailstorm : BattleAction {
    BAHailstorm() : base() {
        $this.Name        = 'Hailstorm'
        $this.Description = 'A common cause of insurace claims.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}
