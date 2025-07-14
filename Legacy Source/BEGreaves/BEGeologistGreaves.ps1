using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGEOLOGISTGREAVES
#
###############################################################################

Class BEGeologistGreaves : BEGreaves {
	BEGeologistGreaves() : base() {
		$this.Name               = 'Geologist Greaves'
		$this.MapObjName         = 'geologistgreaves'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for earth scientists.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
