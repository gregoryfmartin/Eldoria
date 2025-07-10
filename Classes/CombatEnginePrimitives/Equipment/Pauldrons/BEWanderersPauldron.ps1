using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWANDERERSPAULDRON
#
###############################################################################

Class BEWanderersPauldron : BEPauldron {
	BEWanderersPauldron() : base() {
		$this.Name               = 'Wanderer''s Pauldron'
		$this.MapObjName         = 'wandererspauldron'
		$this.PurchasePrice      = 2150
		$this.SellPrice          = 1075
		$this.TargetStats        = @{
			[StatId]::Defense = 43
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by those who roam the wilderness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
