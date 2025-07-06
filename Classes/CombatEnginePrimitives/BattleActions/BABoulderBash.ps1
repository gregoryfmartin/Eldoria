using namespace System

Set-StrictMode -Version Latest

Class BABoulderBash : BattleAction {
    BABoulderBash() : base() {
        $this.Name        = 'Boulder Bash'
        $this.Description = 'We played Resident Evil 5 to the end.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}
