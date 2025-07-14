using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETWILIGHTBROOCH
#
###############################################################################

Class BETwilightBrooch : BEJewelry {
	BETwilightBrooch() : base() {
		$this.Name               = 'Twilight Brooch'
		$this.MapObjName         = 'twilightbrooch'
		$this.PurchasePrice      = 920
		$this.SellPrice          = 460
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch that shimmers with the colors of dusk.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
