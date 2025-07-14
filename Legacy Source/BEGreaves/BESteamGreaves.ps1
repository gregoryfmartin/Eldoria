using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTEAMGREAVES
#
###############################################################################

Class BESteamGreaves : BEGreaves {
	BESteamGreaves() : base() {
		$this.Name               = 'Steam Greaves'
		$this.MapObjName         = 'steamgreaves'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves powered by steam, heavy but powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
