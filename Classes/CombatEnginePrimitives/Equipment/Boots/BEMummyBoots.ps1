using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMUMMYBOOTS
#
###############################################################################

Class BEMummyBoots : BEBoots {
	BEMummyBoots() : base() {
		$this.Name               = 'Mummy Boots'
		$this.MapObjName         = 'mummyboots'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bandaged boots, ancient and cursed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
