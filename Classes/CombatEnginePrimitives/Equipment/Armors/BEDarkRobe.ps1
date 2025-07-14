using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDARKROBE
#
###############################################################################

Class BEDarkRobe : BEArmor {
	BEDarkRobe() : base() {
		$this.Name               = 'Dark Robe'
		$this.MapObjName         = 'darkrobe'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A foreboding robe, favored by shadow mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
