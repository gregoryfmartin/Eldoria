using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ARTISAN'S BERET
#
###############################################################################

Class BEArtisansBeret : BEHelmet {
	BEArtisansBeret() : base() {
		$this.Name               = 'Artisan''s Beret'
		$this.MapObjName         = 'artisansberet'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stylish beret worn by artisans, inspiring creativity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
