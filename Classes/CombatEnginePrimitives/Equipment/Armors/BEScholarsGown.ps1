using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCHOLARSGOWN
#
###############################################################################

Class BEScholarsGown : BEArmor {
	BEScholarsGown() : base() {
		$this.Name               = 'Scholar''s Gown'
		$this.MapObjName         = 'scholarsgown'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dignified gown for intellectual pursuits, very comfortable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
