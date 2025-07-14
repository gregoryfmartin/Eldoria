using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRIMSONSORCERESSCAPE
#
###############################################################################

Class BECrimsonSorceressCape : BECape {
	BECrimsonSorceressCape() : base() {
		$this.Name               = 'Crimson Sorceress Cape'
		$this.MapObjName         = 'crimsonsorceresscape'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A deep red cape, favored by powerful female magic users.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
