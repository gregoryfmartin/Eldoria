using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYSTICLEATHERGAUNTLETS
#
###############################################################################

Class BEMysticLeatherGauntlets : BEGauntlets {
	BEMysticLeatherGauntlets() : base() {
		$this.Name               = 'Mystic Leather Gauntlets'
		$this.MapObjName         = 'mysticleathergauntlets'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Leather gauntlets infused with minor protective charms.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
