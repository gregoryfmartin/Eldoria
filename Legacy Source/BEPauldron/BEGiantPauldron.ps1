using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGIANTPAULDRON
#
###############################################################################

Class BEGiantPauldron : BEPauldron {
	BEGiantPauldron() : base() {
		$this.Name               = 'Giant Pauldron'
		$this.MapObjName         = 'giantpauldron'
		$this.PurchasePrice      = 6000
		$this.SellPrice          = 3000
		$this.TargetStats        = @{
			[StatId]::Defense = 120
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Scaled for immense warriors, offering formidable defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
