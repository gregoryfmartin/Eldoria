using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEECLIPSEPENDANT
#
###############################################################################

Class BEEclipsePendant : BEJewelry {
	BEEclipsePendant() : base() {
		$this.Name               = 'Eclipse Pendant'
		$this.MapObjName         = 'eclipsependant'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark pendant resembling an eclipse, symbolizing balance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
