using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESENTINELGREAVES
#
###############################################################################

Class BESentinelGreaves : BEGreaves {
	BESentinelGreaves() : base() {
		$this.Name               = 'Sentinel Greaves'
		$this.MapObjName         = 'sentinelgreaves'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy greaves designed for defensive stances.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
