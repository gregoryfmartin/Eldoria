using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARFALLROBE
#
###############################################################################

Class BEStarfallRobe : BEArmor {
	BEStarfallRobe() : base() {
		$this.Name               = 'Starfall Robe'
		$this.MapObjName         = 'starfallrobe'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe said to be woven from threads of falling stars, grants incredible power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
