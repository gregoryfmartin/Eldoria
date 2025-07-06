using namespace System

Set-StrictMode -Version Latest

Class BASwordSlash : BattleAction {
    BASwordSlash() : base() {
        $this.Name        = 'Sword Slash'
        $this.Description = 'A basic sword attack.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 60
        $this.Chance      = 1.0
    }
}
