using namespace System

Set-StrictMode -Version Latest

Class BAChillSlash : BattleAction {
    BAChillSlash() : base() {
        $this.Name        = 'Chill Slash'
        $this.Description = 'Let''s all cool down, yeah?'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}
