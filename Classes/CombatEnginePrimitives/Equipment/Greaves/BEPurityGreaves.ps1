using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPURITYGREAVES
#
###############################################################################

Class BEPurityGreaves : BEGreaves {
	BEPurityGreaves() : base() {
		$this.Name               = 'Purity Greaves'
		$this.MapObjName         = 'puritygreaves'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of untainted essence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
