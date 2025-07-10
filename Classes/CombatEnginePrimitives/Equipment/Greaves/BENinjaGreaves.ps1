using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENINJAGREAVES
#
###############################################################################

Class BENinjaGreaves : BEGreaves {
	BENinjaGreaves() : base() {
		$this.Name               = 'Ninja Greaves'
		$this.MapObjName         = 'ninjagreaves'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 18
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and silent greaves for covert operations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
