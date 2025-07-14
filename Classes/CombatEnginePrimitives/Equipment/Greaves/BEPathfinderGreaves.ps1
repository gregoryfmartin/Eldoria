using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPATHFINDERGREAVES
#
###############################################################################

Class BEPathfinderGreaves : BEGreaves {
	BEPathfinderGreaves() : base() {
		$this.Name               = 'Pathfinder Greaves'
		$this.MapObjName         = 'pathfindergreaves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 12
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for charting unknown territories.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
