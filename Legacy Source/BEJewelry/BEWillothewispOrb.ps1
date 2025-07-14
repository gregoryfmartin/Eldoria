using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWILLOTHEWISPORB
#
###############################################################################

Class BEWillothewispOrb : BEJewelry {
	BEWillothewispOrb() : base() {
		$this.Name               = 'Willothewisp Orb'
		$this.MapObjName         = 'willothewisporb'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small orb that floats and bobs like a will-o-the-wisp.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
