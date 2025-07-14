using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVINDICATORBOOTS
#
###############################################################################

Class BEVindicatorBoots : BEBoots {
	BEVindicatorBoots() : base() {
		$this.Name               = 'Vindicator Boots'
		$this.MapObjName         = 'vindicatorboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of justified defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
