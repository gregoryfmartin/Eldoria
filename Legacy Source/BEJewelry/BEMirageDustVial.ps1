using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMIRAGEDUSTVIAL
#
###############################################################################

Class BEMirageDustVial : BEJewelry {
	BEMirageDustVial() : base() {
		$this.Name               = 'Mirage Dust Vial'
		$this.MapObjName         = 'miragedustvial'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vial of shimmering dust that creates illusions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
