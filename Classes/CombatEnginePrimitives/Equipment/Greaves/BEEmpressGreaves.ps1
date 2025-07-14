using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMPRESSGREAVES
#
###############################################################################

Class BEEmpressGreaves : BEGreaves {
	BEEmpressGreaves() : base() {
		$this.Name               = 'Empress Greaves'
		$this.MapObjName         = 'empressgreaves'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 58
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a powerful female ruler.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
