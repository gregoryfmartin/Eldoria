using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPATHFINDERBOOTS
#
###############################################################################

Class BEPathfinderBoots : BEBoots {
	BEPathfinderBoots() : base() {
		$this.Name               = 'Pathfinder Boots'
		$this.MapObjName         = 'pathfinderboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 10
			[StatId]::Speed = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for charting unknown territories.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
