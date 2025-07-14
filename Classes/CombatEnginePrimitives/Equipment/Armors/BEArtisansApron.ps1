using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARTISANSAPRON
#
###############################################################################

Class BEArtisansApron : BEArmor {
	BEArtisansApron() : base() {
		$this.Name               = 'Artisan''s Apron'
		$this.MapObjName         = 'artisansapron'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical apron with many pockets, good for crafting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
