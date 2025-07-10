using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYSTICSTHIRDEYE
#
###############################################################################

Class BEMysticsThirdEye : BEJewelry {
	BEMysticsThirdEye() : base() {
		$this.Name               = 'Mystic''s Third Eye'
		$this.MapObjName         = 'mysticsthirdeye'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Accuracy = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An eye-shaped gem, for enhanced perception.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
