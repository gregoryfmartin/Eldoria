using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHYDRAGREAVES
#
###############################################################################

Class BEHydraGreaves : BEGreaves {
	BEHydraGreaves() : base() {
		$this.Name               = 'Hydra Greaves'
		$this.MapObjName         = 'hydragreaves'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 58
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of multi-headed beasts, regenerating.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
