using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPECTERSROBE
#
###############################################################################

Class BESpectersRobe : BEArmor {
	BESpectersRobe() : base() {
		$this.Name               = 'Specter''s Robe'
		$this.MapObjName         = 'spectersrobe'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ghostly robe that grants a small chance to evade attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
