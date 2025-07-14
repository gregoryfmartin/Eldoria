using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLACIERPAULDRON
#
###############################################################################

Class BEGlacierPauldron : BEPauldron {
	BEGlacierPauldron() : base() {
		$this.Name               = 'Glacier Pauldron'
		$this.MapObjName         = 'glacierpauldron'
		$this.PurchasePrice      = 2650
		$this.SellPrice          = 1325
		$this.TargetStats        = @{
			[StatId]::Defense = 53
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Provides warmth and protection in freezing conditions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
