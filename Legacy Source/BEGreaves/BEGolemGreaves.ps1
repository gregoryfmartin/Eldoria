using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLEMGREAVES
#
###############################################################################

Class BEGolemGreaves : BEGreaves {
	BEGolemGreaves() : base() {
		$this.Name               = 'Golem Greaves'
		$this.MapObjName         = 'golemgreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves crafted from enchanted stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
