using namespace System

Set-StrictMode -Version Latest

Class BABreezeBlade : BattleAction {
    BABreezeBlade() : base() {
        $this.Name        = 'Breeze Blade'
        $this.Description = 'Easy, breezy, bleedy, dying guy.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}
