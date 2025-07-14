using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMUMMYGREAVES
#
###############################################################################

Class BEMummyGreaves : BEGreaves {
	BEMummyGreaves() : base() {
		$this.Name               = 'Mummy Greaves'
		$this.MapObjName         = 'mummygreaves'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bandaged greaves, ancient and cursed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
