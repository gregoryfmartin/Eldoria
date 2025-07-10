using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOLCANOEMBER
#
###############################################################################

Class BEVolcanoEmber : BEJewelry {
	BEVolcanoEmber() : base() {
		$this.Name               = 'Volcano Ember'
		$this.MapObjName         = 'volcanoember'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicAttack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small ember from a volcano, radiating heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
