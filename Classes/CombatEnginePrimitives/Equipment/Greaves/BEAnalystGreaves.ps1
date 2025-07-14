using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEANALYSTGREAVES
#
###############################################################################

Class BEAnalystGreaves : BEGreaves {
	BEAnalystGreaves() : base() {
		$this.Name               = 'Analyst Greaves'
		$this.MapObjName         = 'analystgreaves'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for data examination.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
