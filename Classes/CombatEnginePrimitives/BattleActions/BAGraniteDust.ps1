using namespace System

Set-StrictMode -Version Latest

Class BAGraniteDust : BattleAction {
    BAGraniteDust() : base() {
        $this.Name        = 'Granite Dust'
        $this.Description = 'There''s blood on the ground before you know it.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}
