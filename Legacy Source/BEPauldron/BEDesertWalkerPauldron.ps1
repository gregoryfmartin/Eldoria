using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDESERTWALKERPAULDRON
#
###############################################################################

Class BEDesertWalkerPauldron : BEPauldron {
	BEDesertWalkerPauldron() : base() {
		$this.Name               = 'Desert Walker Pauldron'
		$this.MapObjName         = 'desertwalkerpauldron'
		$this.PurchasePrice      = 2550
		$this.SellPrice          = 1275
		$this.TargetStats        = @{
			[StatId]::Defense = 51
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Designed for endurance in arid environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
