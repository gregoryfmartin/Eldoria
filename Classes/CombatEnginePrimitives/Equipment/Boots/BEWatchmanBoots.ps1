using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWATCHMANBOOTS
#
###############################################################################

Class BEWatchmanBoots : BEBoots {
	BEWatchmanBoots() : base() {
		$this.Name               = 'Watchman Boots'
		$this.MapObjName         = 'watchmanboots'
		$this.PurchasePrice      = 630
		$this.SellPrice          = 315
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for night patrols.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
