using namespace System

Set-StrictMode -Version Latest

Class BAEarthCataclysm : BattleAction {
    BAEarthCataclysm() : base() {
        $this.Name        = "`u{03B5} Cataclysm"
        $this.Description = 'A rocky death rains down on you.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.MpCost      = 400
        $this.EffectValue = 2000
        $this.Chance      = 0.1
    }
}
