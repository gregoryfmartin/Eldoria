using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMAGESTUNIC
#
###############################################################################

Class BEMagesTunic : BEArmor {
	BEMagesTunic() : base() {
		$this.Name               = 'Mage''s Tunic'
		$this.MapObjName         = 'magestunic'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A comfortable tunic that aids in spellcasting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
