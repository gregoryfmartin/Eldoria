using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOSMICFORGEPAULDRON
#
###############################################################################

Class BECosmicForgePauldron : BEPauldron {
	BECosmicForgePauldron() : base() {
		$this.Name               = 'Cosmic Forge Pauldron'
		$this.MapObjName         = 'cosmicforgepauldron'
		$this.PurchasePrice      = 6700
		$this.SellPrice          = 3350
		$this.TargetStats        = @{
			[StatId]::Defense = 134
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Forged at the birth of the universe, incredibly powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
