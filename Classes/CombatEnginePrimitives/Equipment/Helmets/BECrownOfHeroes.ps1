using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECROWNOFHEROES
#
###############################################################################

Class BECrownofHeroes : BEHelmet {
	BECrownofHeroes() : base() {
		$this.Name               = 'Crown of Heroes'
		$this.MapObjName         = 'crownofheroes'
		$this.PurchasePrice      = 5000
		$this.SellPrice          = 2500
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary crown worn by ancient heroes, said to inspire courage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
