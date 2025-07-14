using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARTISANBOOTS
#
###############################################################################

Class BEArtisanBoots : BEBoots {
	BEArtisanBoots() : base() {
		$this.Name               = 'Artisan Boots'
		$this.MapObjName         = 'artisanboots'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by skilled craftspeople.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
