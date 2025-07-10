using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMASTERGREAVES
#
###############################################################################

Class BEMasterGreaves : BEGreaves {
	BEMasterGreaves() : base() {
		$this.Name               = 'Master Greaves'
		$this.MapObjName         = 'mastergreaves'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves worn by true masters of their craft.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
