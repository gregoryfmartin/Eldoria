using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHUNTRESSPAULDRON
#
###############################################################################

Class BEHuntressPauldron : BEPauldron {
	BEHuntressPauldron() : base() {
		$this.Name               = 'Huntress Pauldron'
		$this.MapObjName         = 'huntresspauldron'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for agile movement while offering decent protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
