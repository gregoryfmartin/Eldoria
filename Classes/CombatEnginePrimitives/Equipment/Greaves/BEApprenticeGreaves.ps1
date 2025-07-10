using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAPPRENTICEGREAVES
#
###############################################################################

Class BEApprenticeGreaves : BEGreaves {
	BEApprenticeGreaves() : base() {
		$this.Name               = 'Apprentice Greaves'
		$this.MapObjName         = 'apprenticegreaves'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic greaves for aspiring adventurers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
