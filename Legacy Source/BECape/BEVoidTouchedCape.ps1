using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDTOUCHEDCAPE
#
###############################################################################

Class BEVoidTouchedCape : BECape {
	BEVoidTouchedCape() : base() {
		$this.Name               = 'Void Touched Cape'
		$this.MapObjName         = 'voidtouchedcape'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape that seems to draw power from the void, unsettling yet potent.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Male
	}
}
