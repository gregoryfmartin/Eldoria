using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLAZEHEART
#
###############################################################################

Class BEBlazeHeart : BEJewelry {
	BEBlazeHeart() : base() {
		$this.Name               = 'Blaze Heart'
		$this.MapObjName         = 'blazeheart'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Attack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, pulsating gem that burns with intense heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
