using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIVINEAEGISGLOVES
#
###############################################################################

Class BEDivineAegisGloves : BEGauntlets {
	BEDivineAegisGloves() : base() {
		$this.Name               = 'Divine Aegis Gloves'
		$this.MapObjName         = 'divineaegisgloves'
		$this.PurchasePrice      = 1650
		$this.SellPrice          = 825
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 52
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that provide an invisible shield, divinely powered.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
