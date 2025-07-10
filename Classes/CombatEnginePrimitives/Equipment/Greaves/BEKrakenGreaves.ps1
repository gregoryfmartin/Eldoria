using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKRAKENGREAVES
#
###############################################################################

Class BEKrakenGreaves : BEGreaves {
	BEKrakenGreaves() : base() {
		$this.Name               = 'Kraken Greaves'
		$this.MapObjName         = 'krakengreaves'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 52
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves from the depths, granting water resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
