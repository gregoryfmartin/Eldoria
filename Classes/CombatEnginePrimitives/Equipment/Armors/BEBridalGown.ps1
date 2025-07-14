using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBRIDALGOWN
#
###############################################################################

Class BEBridalGown : BEArmor {
	BEBridalGown() : base() {
		$this.Name               = 'Bridal Gown'
		$this.MapObjName         = 'bridalgown'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A beautiful white gown, worn for ceremonies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
