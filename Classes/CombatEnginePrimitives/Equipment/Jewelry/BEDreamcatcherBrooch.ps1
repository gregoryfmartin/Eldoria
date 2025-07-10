using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMCATCHERBROOCH
#
###############################################################################

Class BEDreamcatcherBrooch : BEJewelry {
	BEDreamcatcherBrooch() : base() {
		$this.Name               = 'Dreamcatcher Brooch'
		$this.MapObjName         = 'dreamcatcherbrooch'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate brooch woven to capture pleasant dreams.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Female
	}
}
