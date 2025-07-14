using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELOGISTICSGREAVES
#
###############################################################################

Class BELogisticsGreaves : BEGreaves {
	BELogisticsGreaves() : base() {
		$this.Name               = 'Logistics Greaves'
		$this.MapObjName         = 'logisticsgreaves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for supply management.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
