using namespace System

Set-StrictMode -Version Latest

Class BAKnifeStab : BattleAction {
    BAKnifeStab() : base() {
        $this.Name        = 'Knife Stab'
        $this.Description = 'Just a little prick, right?'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 40
        $this.Chance      = 0.9
    }
}
