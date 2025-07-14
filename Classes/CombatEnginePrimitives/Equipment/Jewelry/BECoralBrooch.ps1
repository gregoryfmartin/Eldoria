using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECORALBROOCH
#
###############################################################################

Class BECoralBrooch : BEJewelry {
	BECoralBrooch() : base() {
		$this.Name               = 'Coral Brooch'
		$this.MapObjName         = 'coralbrooch'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate coral brooch, whispering of ocean depths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
