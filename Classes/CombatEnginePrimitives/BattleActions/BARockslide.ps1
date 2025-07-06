using namespace System

Set-StrictMode -Version Latest

Class BARockslide : BattleAction {
    BARockslide() : base() {
        $this.Name        = 'Rockslide'
        $this.Description = 'Fallin'' rocks, fallin'' rocks, fallin'' rocks.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}
