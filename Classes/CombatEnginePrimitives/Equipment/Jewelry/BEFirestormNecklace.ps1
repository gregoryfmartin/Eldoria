using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFIRESTORMNECKLACE
#
###############################################################################

Class BEFirestormNecklace : BEJewelry {
	BEFirestormNecklace() : base() {
		$this.Name               = 'Firestorm Necklace'
		$this.MapObjName         = 'firestormnecklace'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Attack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A necklace that feels warm to the touch, capable of igniting minor flames.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
