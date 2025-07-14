using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEANALYSTBOOTS
#
###############################################################################

Class BEAnalystBoots : BEBoots {
	BEAnalystBoots() : base() {
		$this.Name               = 'Analyst Boots'
		$this.MapObjName         = 'analystboots'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for data examination.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
