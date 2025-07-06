using namespace System

Set-StrictMode -Version Latest

Class BAFireball : BattleAction {
    BAFireball() : base() {
        $this.Name        = 'Fireball'
        $this.Description = 'That''s a spicy meatball!'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 7
        $this.EffectValue = 80
        $this.Chance      = 0.75
    }
}
