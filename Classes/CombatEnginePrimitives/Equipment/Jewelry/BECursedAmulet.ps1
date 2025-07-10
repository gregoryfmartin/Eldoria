using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECURSEDAMULET
#
###############################################################################

Class BECursedAmulet : BEJewelry {
	BECursedAmulet() : base() {
		$this.Name               = 'Cursed Amulet'
		$this.MapObjName         = 'cursedamulet'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An amulet that brings misfortune to its wearer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
