using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELOGISTICSBOOTS
#
###############################################################################

Class BELogisticsBoots : BEBoots {
	BELogisticsBoots() : base() {
		$this.Name               = 'Logistics Boots'
		$this.MapObjName         = 'logisticsboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for supply management.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
