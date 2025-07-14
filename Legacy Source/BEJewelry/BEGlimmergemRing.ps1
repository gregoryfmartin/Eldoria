using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLIMMERGEMRING
#
###############################################################################

Class BEGlimmergemRing : BEJewelry {
	BEGlimmergemRing() : base() {
		$this.Name               = 'Glimmergem Ring'
		$this.MapObjName         = 'glimmergemring'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring with a gem that always seems to glimmer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
