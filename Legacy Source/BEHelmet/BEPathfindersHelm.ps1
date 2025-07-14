using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPATHFINDERSHELM
#
###############################################################################

Class BEPathfindersHelm : BEHelmet {
	BEPathfindersHelm() : base() {
		$this.Name               = 'Pathfinder''s Helm'
		$this.MapObjName         = 'pathfindershelm'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that helps pathfinders navigate treacherous terrain.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
