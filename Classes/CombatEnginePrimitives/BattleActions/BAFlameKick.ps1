using namespace System

Set-StrictMode -Version Latest

Class BAFlameKick : BattleAction {
    BAFlameKick() : base() {
        $this.Name        = 'Flame Kick'
        $this.Description = 'I got channed heat on my heels.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 5
        $this.EffectValue = 85
        $this.Chance      = 0.9
    }
}
