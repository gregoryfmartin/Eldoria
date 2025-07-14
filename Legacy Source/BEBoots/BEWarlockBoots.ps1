using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARLOCKBOOTS
#
###############################################################################

Class BEWarlockBoots : BEBoots {
	BEWarlockBoots() : base() {
		$this.Name               = 'Warlock Boots'
		$this.MapObjName         = 'warlockboots'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those who dabble in dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
