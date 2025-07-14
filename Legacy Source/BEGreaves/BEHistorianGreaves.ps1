using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHISTORIANGREAVES
#
###############################################################################

Class BEHistorianGreaves : BEGreaves {
	BEHistorianGreaves() : base() {
		$this.Name               = 'Historian Greaves'
		$this.MapObjName         = 'historiangreaves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for those who study the past.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
