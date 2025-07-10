using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMILITIAGREAVES
#
###############################################################################

Class BEMilitiaGreaves : BEGreaves {
	BEMilitiaGreaves() : base() {
		$this.Name               = 'Militia Greaves'
		$this.MapObjName         = 'militiagreaves'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for civilian defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
