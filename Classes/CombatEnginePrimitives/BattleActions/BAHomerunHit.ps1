using namespace System

Set-StrictMode -Version Latest

Class BAHomerunHit : BattleAction {
    BAHomerunHit() : base() {
        $this.Name        = 'Homerun Hit'
        $this.Description = 'Swing, batter... SWING!'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 200
        $this.Chance      = 0.1
    }
}
