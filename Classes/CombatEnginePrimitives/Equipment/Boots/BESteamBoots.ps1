using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTEAMBOOTS
#
###############################################################################

Class BESteamBoots : BEBoots {
	BESteamBoots() : base() {
		$this.Name               = 'Steam Boots'
		$this.MapObjName         = 'steamboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots powered by steam, heavy but powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
