using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDUSKPETALEARRING
#
###############################################################################

Class BEDuskpetalEarring : BEJewelry {
	BEDuskpetalEarring() : base() {
		$this.Name               = 'Duskpetal Earring'
		$this.MapObjName         = 'duskpetalearring'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An earring made from a petal that blooms only at dusk.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
