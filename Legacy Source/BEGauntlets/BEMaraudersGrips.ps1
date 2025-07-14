using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMARAUDERSGRIPS
#
###############################################################################

Class BEMaraudersGrips : BEGauntlets {
	BEMaraudersGrips() : base() {
		$this.Name               = 'Marauder''s Grips'
		$this.MapObjName         = 'maraudersgrips'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Rough grips favored by raiders, for brutal attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
