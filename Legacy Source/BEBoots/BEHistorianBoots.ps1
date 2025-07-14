using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHISTORIANBOOTS
#
###############################################################################

Class BEHistorianBoots : BEBoots {
	BEHistorianBoots() : base() {
		$this.Name               = 'Historian Boots'
		$this.MapObjName         = 'historianboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those who study the past.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
