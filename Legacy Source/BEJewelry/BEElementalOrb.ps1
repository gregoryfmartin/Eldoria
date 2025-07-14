using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELEMENTALORB
#
###############################################################################

Class BEElementalOrb : BEJewelry {
	BEElementalOrb() : base() {
		$this.Name               = 'Elemental Orb'
		$this.MapObjName         = 'elementalorb'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A glowing orb containing elemental power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
