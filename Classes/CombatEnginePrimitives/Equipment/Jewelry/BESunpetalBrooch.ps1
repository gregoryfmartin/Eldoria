using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNPETALBROOCH
#
###############################################################################

Class BESunpetalBrooch : BEJewelry {
	BESunpetalBrooch() : base() {
		$this.Name               = 'Sunpetal Brooch'
		$this.MapObjName         = 'sunpetalbrooch'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch made from a petal warmed by sunlight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
