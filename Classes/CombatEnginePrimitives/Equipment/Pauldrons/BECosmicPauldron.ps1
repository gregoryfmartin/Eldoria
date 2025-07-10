using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOSMICPAULDRON
#
###############################################################################

Class BECosmicPauldron : BEPauldron {
	BECosmicPauldron() : base() {
		$this.Name               = 'Cosmic Pauldron'
		$this.MapObjName         = 'cosmicpauldron'
		$this.PurchasePrice      = 4550
		$this.SellPrice          = 2275
		$this.TargetStats        = @{
			[StatId]::Defense = 91
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Connects to the vastness of the cosmos, granting immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
