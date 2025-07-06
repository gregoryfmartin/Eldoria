using namespace System

Set-StrictMode -Version Latest

Class BALightCataclysm : BattleAction {
    BALightCataclysm() : base() {
        $this.Name        = "`u{03BC} Cataclysm"
        $this.Description = 'Holy death rains down upon you.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.MpCost      = 500
        $this.EffectValue = 2500
        $this.Chance      = 0.1
    }
}
