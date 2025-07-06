using namespace System

Set-StrictMode -Version Latest

Class BAHolyNova : BattleAction {
    BAHolyNova() : base() {
        $this.Name        = 'Holy Nova'
        $this.Description = 'More Bible than you can handle.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}
