using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEACTORSMASKPIN
#
###############################################################################

Class BEActorsMaskPin : BEJewelry {
	BEActorsMaskPin() : base() {
		$this.Name               = 'Actor''s Mask Pin'
		$this.MapObjName         = 'actorsmaskpin'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a theatrical mask, for performance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
