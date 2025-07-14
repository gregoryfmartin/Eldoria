using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENIGHTWALKERSHROUD
#
###############################################################################

Class BENightWalkerShroud : BEJewelry {
	BENightWalkerShroud() : base() {
		$this.Name               = 'Night Walker Shroud'
		$this.MapObjName         = 'nightwalkershroud'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small piece of shroud that aids in moving unseen.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Male
	}
}
