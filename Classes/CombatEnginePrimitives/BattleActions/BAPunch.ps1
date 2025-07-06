using namespace System

Set-StrictMode -Version Latest

Class BAPunch : BattleAction {
    BAPunch() : base() {
        $this.Name        = 'Punch'
        $this.Description = 'A punch. Just like dad taught you.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 50
        $this.Chance      = 1.0
    }
}
