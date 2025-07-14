using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKNIGHTCAPE
#
###############################################################################

Class BEKnightCape : BECape {
	BEKnightCape() : base() {
		$this.Name               = 'Knight Cape'
		$this.MapObjName         = 'knightcape'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy cape, signifying duty and honor.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Male
	}
}
