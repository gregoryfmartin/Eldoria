using namespace System

Set-StrictMode -Version Latest

Class BABreezyWind : BattleAction {
    BABreezyWind() : base() {
        $this.Name        = 'Breezy Wind'
        $this.Description = 'So brisk it''ll carry her bonnet off.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}
