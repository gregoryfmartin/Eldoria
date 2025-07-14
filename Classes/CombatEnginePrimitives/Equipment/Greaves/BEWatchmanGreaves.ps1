using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWATCHMANGREAVES
#
###############################################################################

Class BEWatchmanGreaves : BEGreaves {
	BEWatchmanGreaves() : base() {
		$this.Name               = 'Watchman Greaves'
		$this.MapObjName         = 'watchmangreaves'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for night patrols.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
