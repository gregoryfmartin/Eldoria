using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIVINEAEGISBREASTPLATE
#
###############################################################################

Class BEDivineAegisBreastplate : BEArmor {
	BEDivineAegisBreastplate() : base() {
		$this.Name               = 'Divine Aegis Breastplate'
		$this.MapObjName         = 'divineaegisbreastplate'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 24
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate radiating holy light, offering strong defense against evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
