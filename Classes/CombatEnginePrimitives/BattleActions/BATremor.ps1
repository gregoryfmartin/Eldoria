using namespace System

Set-StrictMode -Version Latest

Class BATremor : BattleAction {
    BATremor() : base() {
        $this.Name        = 'Tremor'
        $this.Description = 'Does more damage than those Kevin Bacon movies.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}
