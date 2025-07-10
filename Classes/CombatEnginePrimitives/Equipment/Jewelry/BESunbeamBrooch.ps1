using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNBEAMBROOCH
#
###############################################################################

Class BESunbeamBrooch : BEJewelry {
	BESunbeamBrooch() : base() {
		$this.Name               = 'Sunbeam Brooch'
		$this.MapObjName         = 'sunbeambrooch'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch that captures a single, perpetual sunbeam.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
