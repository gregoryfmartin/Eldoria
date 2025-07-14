using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIVINEAEGIS
#
###############################################################################

Class BEDivineAegis : BEGauntlets {
	BEDivineAegis() : base() {
		$this.Name               = 'Divine Aegis'
		$this.MapObjName         = 'divineaegis'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets offering supreme divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
