using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIVINEROBE
#
###############################################################################

Class BEDivineRobe : BEArmor {
	BEDivineRobe() : base() {
		$this.Name               = 'Divine Robe'
		$this.MapObjName         = 'divinerobe'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe of unparalleled purity, offering divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
