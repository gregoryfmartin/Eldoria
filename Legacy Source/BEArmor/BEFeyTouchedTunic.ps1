using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFEYTOUCHEDTUNIC
#
###############################################################################

Class BEFeyTouchedTunic : BEArmor {
	BEFeyTouchedTunic() : base() {
		$this.Name               = 'Fey-Touched Tunic'
		$this.MapObjName         = 'feytouchedtunic'
		$this.PurchasePrice      = 260
		$this.SellPrice          = 130
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic seemingly woven from forest leaves, offering minor magical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
