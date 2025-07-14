using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFROSTBITERING
#
###############################################################################

Class BEFrostbiteRing : BEJewelry {
	BEFrostbiteRing() : base() {
		$this.Name               = 'Frostbite Ring'
		$this.MapObjName         = 'frostbitering'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring that chills the finger, capable of producing ice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
