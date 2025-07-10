using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEALCHEMISTSMORTARPIN
#
###############################################################################

Class BEAlchemistsMortarPin : BEJewelry {
	BEAlchemistsMortarPin() : base() {
		$this.Name               = 'Alchemist''s Mortar Pin'
		$this.MapObjName         = 'alchemistsmortarpin'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a mortar and pestle, for potions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
