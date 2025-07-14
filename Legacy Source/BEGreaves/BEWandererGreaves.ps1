using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWANDERERGREAVES
#
###############################################################################

Class BEWandererGreaves : BEGreaves {
	BEWandererGreaves() : base() {
		$this.Name               = 'Wanderer Greaves'
		$this.MapObjName         = 'wanderergreaves'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 6
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for eternal travelers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
