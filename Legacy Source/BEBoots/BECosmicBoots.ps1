using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOSMICBOOTS
#
###############################################################################

Class BECosmicBoots : BEBoots {
	BECosmicBoots() : base() {
		$this.Name               = 'Cosmic Boots'
		$this.MapObjName         = 'cosmicboots'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of the cosmos, vast and powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
