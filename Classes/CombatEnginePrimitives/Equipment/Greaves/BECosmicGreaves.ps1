using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOSMICGREAVES
#
###############################################################################

Class BECosmicGreaves : BEGreaves {
	BECosmicGreaves() : base() {
		$this.Name               = 'Cosmic Greaves'
		$this.MapObjName         = 'cosmicgreaves'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of the cosmos, vast and powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
