using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVANGUARDBOOTS
#
###############################################################################

Class BEVanguardBoots : BEBoots {
	BEVanguardBoots() : base() {
		$this.Name               = 'Vanguard Boots'
		$this.MapObjName         = 'vanguardboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for the front lines of battle.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
