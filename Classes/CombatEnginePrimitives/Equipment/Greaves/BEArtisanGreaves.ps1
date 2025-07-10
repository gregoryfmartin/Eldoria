using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARTISANGREAVES
#
###############################################################################

Class BEArtisanGreaves : BEGreaves {
	BEArtisanGreaves() : base() {
		$this.Name               = 'Artisan Greaves'
		$this.MapObjName         = 'artisangreaves'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves worn by skilled craftspeople.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
