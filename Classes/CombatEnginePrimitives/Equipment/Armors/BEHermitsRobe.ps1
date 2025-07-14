using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHERMITSROBE
#
###############################################################################

Class BEHermitsRobe : BEArmor {
	BEHermitsRobe() : base() {
		$this.Name               = 'Hermit''s Robe'
		$this.MapObjName         = 'hermitsrobe'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A plain, patched robe, worn by reclusive wise individuals.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
