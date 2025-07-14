using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILENTWRAPS
#
###############################################################################

Class BESilentWraps : BEGauntlets {
	BESilentWraps() : base() {
		$this.Name               = 'Silent Wraps'
		$this.MapObjName         = 'silentwraps'
		$this.PurchasePrice      = 140
		$this.SellPrice          = 70
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 7
			[StatId]::Accuracy = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Soft wraps for quiet movement, favored by scouts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
