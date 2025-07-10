using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCHERSQUIVERPIN
#
###############################################################################

Class BEArchersQuiverPin : BEJewelry {
	BEArchersQuiverPin() : base() {
		$this.Name               = 'Archer''s Quiver Pin'
		$this.MapObjName         = 'archersquiverpin'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a small quiver, enhancing precision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
