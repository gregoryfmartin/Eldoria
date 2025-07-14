using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMATRIARCHSGOWN
#
###############################################################################

Class BEMatriarchsGown : BEArmor {
	BEMatriarchsGown() : base() {
		$this.Name               = 'Matriarch''s Gown'
		$this.MapObjName         = 'matriarchsgown'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An imposing gown worn by powerful female leaders.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
