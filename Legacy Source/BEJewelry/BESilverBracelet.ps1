using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILVERBRACELET
#
###############################################################################

Class BESilverBracelet : BEJewelry {
	BESilverBracelet() : base() {
		$this.Name               = 'Silver Bracelet'
		$this.MapObjName         = 'silverbracelet'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate silver bracelet, popular among magic users.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
