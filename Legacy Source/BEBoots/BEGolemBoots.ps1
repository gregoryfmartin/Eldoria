using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLEMBOOTS
#
###############################################################################

Class BEGolemBoots : BEBoots {
	BEGolemBoots() : base() {
		$this.Name               = 'Golem Boots'
		$this.MapObjName         = 'golemboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots crafted from enchanted stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
