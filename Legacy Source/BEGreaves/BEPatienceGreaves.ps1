using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPATIENCEGREAVES
#
###############################################################################

Class BEPatienceGreaves : BEGreaves {
	BEPatienceGreaves() : base() {
		$this.Name               = 'Patience Greaves'
		$this.MapObjName         = 'patiencegreaves'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that foster endurance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
