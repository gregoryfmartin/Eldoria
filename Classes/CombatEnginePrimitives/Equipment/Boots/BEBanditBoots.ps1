using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBANDITBOOTS
#
###############################################################################

Class BEBanditBoots : BEBoots {
	BEBanditBoots() : base() {
		$this.Name               = 'Bandit Boots'
		$this.MapObjName         = 'banditboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots favored by brigands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
