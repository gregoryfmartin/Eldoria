using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROYALGOWN
#
###############################################################################

Class BERoyalGown : BEArmor {
	BERoyalGown() : base() {
		$this.Name               = 'Royal Gown'
		$this.MapObjName         = 'royalgown'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An elegant gown, offering prestige more than protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
