using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMARKSMANSSCOPE
#
###############################################################################

Class BEMarksmansScope : BEJewelry {
	BEMarksmansScope() : base() {
		$this.Name               = 'Marksman''s Scope'
		$this.MapObjName         = 'marksmansscope'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Accuracy = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A miniature scope that enhances accuracy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Male
	}
}
