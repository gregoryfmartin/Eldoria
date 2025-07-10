using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLACIALROBE
#
###############################################################################

Class BEGlacialRobe : BEArmor {
	BEGlacialRobe() : base() {
		$this.Name               = 'Glacial Robe'
		$this.MapObjName         = 'glacialrobe'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 31
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe radiating intense cold, perfect for ice mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
