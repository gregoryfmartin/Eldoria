using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESENTINELBOOTS
#
###############################################################################

Class BESentinelBoots : BEBoots {
	BESentinelBoots() : base() {
		$this.Name               = 'Sentinel Boots'
		$this.MapObjName         = 'sentinelboots'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy boots designed for defensive stances.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
