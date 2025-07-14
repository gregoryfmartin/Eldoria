using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCHOLARGREAVES
#
###############################################################################

Class BEScholarGreaves : BEGreaves {
	BEScholarGreaves() : base() {
		$this.Name               = 'Scholar Greaves'
		$this.MapObjName         = 'scholargreaves'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves worn by academic scholars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
