using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOFFICERGREAVES
#
###############################################################################

Class BEOfficerGreaves : BEGreaves {
	BEOfficerGreaves() : base() {
		$this.Name               = 'Officer Greaves'
		$this.MapObjName         = 'officergreaves'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves worn by military officers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
