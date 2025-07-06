using namespace System

Set-StrictMode -Version Latest

Class BASinkhole : BattleAction {
    BASinkhole() : base() {
        $this.Name        = 'Sinkhole'
        $this.Description = 'Tumbling down the rabbit hole.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.MpCost      = 400
        $this.EffectValue = 2000
        $this.Chance      = 0.1
    }
}
