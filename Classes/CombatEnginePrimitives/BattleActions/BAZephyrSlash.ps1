using namespace System

Set-StrictMode -Version Latest

Class BAZephyrSlash : BattleAction {
    BAZephyrSlash() : base() {
        $this.Name        = 'Zephyr Slash'
        $this.Description = 'What the hell is a zephyr, anyway?'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}
