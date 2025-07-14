using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECLOCKWORKHEART
#
###############################################################################

Class BEClockworkHeart : BEJewelry {
	BEClockworkHeart() : base() {
		$this.Name               = 'Clockwork Heart'
		$this.MapObjName         = 'clockworkheart'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A miniature clockwork heart, ticking softly.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
