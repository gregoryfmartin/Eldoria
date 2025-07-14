using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESACREDTEAR
#
###############################################################################

Class BESacredTear : BEJewelry {
	BESacredTear() : base() {
		$this.Name               = 'Sacred Tear'
		$this.MapObjName         = 'sacredtear'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A drop of solidified sacred tear, offering healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
