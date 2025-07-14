using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHEMISTBOOTS
#
###############################################################################

Class BEChemistBoots : BEBoots {
	BEChemistBoots() : base() {
		$this.Name               = 'Chemist Boots'
		$this.MapObjName         = 'chemistboots'
		$this.PurchasePrice      = 530
		$this.SellPrice          = 265
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for scientific experimenters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
