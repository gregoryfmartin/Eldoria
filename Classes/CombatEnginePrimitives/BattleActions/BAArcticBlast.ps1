using namespace System

Set-StrictMode -Version Latest

Class BAArcticBlast : BattleAction {
    BAArcticBlast() : base() {
        $this.Name        = 'Arctic Blast'
        $this.Description = 'Oh you won''t be long for gettin'' froshbit, now!'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}
