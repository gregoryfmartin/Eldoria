using namespace System

Set-StrictMode -Version Latest

Class BAPeck : BattleAction {
    BAPeck() : base() {
        $this.Name        = 'Peck'
        $this.Description = 'One from Grandma usually means cookies later.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 20
        $this.Chance      = 1.0
    }
}
