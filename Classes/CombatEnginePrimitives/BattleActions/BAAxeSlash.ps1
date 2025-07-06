using namespace System

Set-StrictMode -Version Latest

Class BAAxeSlash : BattleAction {
    BAAxeSlash() : base() {
        $this.Name        = 'Axe Slash'
        $this.Description = 'Chopping trees pays off.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 70
        $this.Chance      = 1.0
    }
}
