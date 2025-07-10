using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOMETTAILEARRING
#
###############################################################################

Class BECometTailEarring : BEJewelry {
	BECometTailEarring() : base() {
		$this.Name               = 'Comet Tail Earring'
		$this.MapObjName         = 'comettailearring'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An earring with a fragment resembling a comet''s tail, increasing speed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
