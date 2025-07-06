using namespace System

Set-StrictMode -Version Latest

Class BAIKill : BattleAction {
    BAIKill() : base() {
        $this.Name        = 'IKill'
        $this.Description = 'Insta death'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 0
        $this.EffectValue = 50000
        $this.Chance      = 1.0
    }
}
