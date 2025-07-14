using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILKROBE
#
###############################################################################

Class BESilkRobe : BEArmor {
	BESilkRobe() : base() {
		$this.Name               = 'Silk Robe'
		$this.MapObjName         = 'silkrobe'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A luxurious robe woven from fine silk, enhancing magical prowess.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
