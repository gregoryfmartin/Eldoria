using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEALCHEMISTSROBE
#
###############################################################################

Class BEAlchemistsRobe : BEArmor {
	BEAlchemistsRobe() : base() {
		$this.Name               = 'Alchemist''s Robe'
		$this.MapObjName         = 'alchemistsrobe'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stained but resilient robe, with many hidden pockets.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
