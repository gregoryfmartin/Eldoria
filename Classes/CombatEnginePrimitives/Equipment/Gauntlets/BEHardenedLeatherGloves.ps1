using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHARDENEDLEATHERGLOVES
#
###############################################################################

Class BEHardenedLeatherGloves : BEGauntlets {
	BEHardenedLeatherGloves() : base() {
		$this.Name               = 'Hardened Leather Gloves'
		$this.MapObjName         = 'hardenedleathergloves'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves of exceptionally tough, treated leather.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
