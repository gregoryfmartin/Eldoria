using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHUNTERSTRAPBADGE
#
###############################################################################

Class BEHuntersTrapBadge : BEJewelry {
	BEHuntersTrapBadge() : base() {
		$this.Name               = 'Hunter''s Trap Badge'
		$this.MapObjName         = 'hunterstrapbadge'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A badge resembling a small trap, for tracking.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
