using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARLOCKSROBE
#
###############################################################################

Class BEWarlocksRobe : BEArmor {
	BEWarlocksRobe() : base() {
		$this.Name               = 'Warlock''s Robe'
		$this.MapObjName         = 'warlocksrobe'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, ominous robe, often associated with forbidden magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
