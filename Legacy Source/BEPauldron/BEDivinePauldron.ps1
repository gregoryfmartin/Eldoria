using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIVINEPAULDRON
#
###############################################################################

Class BEDivinePauldron : BEPauldron {
	BEDivinePauldron() : base() {
		$this.Name               = 'Divine Pauldron'
		$this.MapObjName         = 'divinepauldron'
		$this.PurchasePrice      = 6300
		$this.SellPrice          = 3150
		$this.TargetStats        = @{
			[StatId]::Defense = 126
			[StatId]::MagicDefense = 49
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Imbued with the essence of a god, granting ultimate protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
