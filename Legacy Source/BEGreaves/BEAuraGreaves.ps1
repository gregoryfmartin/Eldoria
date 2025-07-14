using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAURAGREAVES
#
###############################################################################

Class BEAuraGreaves : BEGreaves {
	BEAuraGreaves() : base() {
		$this.Name               = 'Aura Greaves'
		$this.MapObjName         = 'auragreaves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that emanate a protective aura.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
