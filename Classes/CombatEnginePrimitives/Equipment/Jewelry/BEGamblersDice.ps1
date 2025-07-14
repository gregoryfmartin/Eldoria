using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGAMBLERSDICE
#
###############################################################################

Class BEGamblersDice : BEJewelry {
	BEGamblersDice() : base() {
		$this.Name               = 'Gambler''s Dice'
		$this.MapObjName         = 'gamblersdice'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Luck = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny pair of perpetually tumbling dice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
