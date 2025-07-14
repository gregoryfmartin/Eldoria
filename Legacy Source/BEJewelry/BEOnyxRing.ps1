using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEONYXRING
#
###############################################################################

Class BEOnyxRing : BEJewelry {
	BEOnyxRing() : base() {
		$this.Name               = 'Onyx Ring'
		$this.MapObjName         = 'onyxring'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A jet black onyx ring, absorbing negative energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
