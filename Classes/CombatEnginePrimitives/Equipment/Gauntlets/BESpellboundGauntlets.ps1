using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPELLBOUNDGAUNTLETS
#
###############################################################################

Class BESpellboundGauntlets : BEGauntlets {
	BESpellboundGauntlets() : base() {
		$this.Name               = 'Spellbound Gauntlets'
		$this.MapObjName         = 'spellboundgauntlets'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets imbued with a powerful, protective spell.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
