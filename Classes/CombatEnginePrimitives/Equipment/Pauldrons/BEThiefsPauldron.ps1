using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHIEFSPAULDRON
#
###############################################################################

Class BEThiefsPauldron : BEPauldron {
	BEThiefsPauldron() : base() {
		$this.Name               = 'Thief''s Pauldron'
		$this.MapObjName         = 'thiefspauldron'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 36
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for quick escapes and silent movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
