using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRIMSONCOURTGOWN
#
###############################################################################

Class BECrimsonCourtGown : BEArmor {
	BECrimsonCourtGown() : base() {
		$this.Name               = 'Crimson Court Gown'
		$this.MapObjName         = 'crimsoncourtgown'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A luxurious crimson gown, granting slight magical allure.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
