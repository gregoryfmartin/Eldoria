using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEECLIPSEPAULDRON
#
###############################################################################

Class BEEclipsePauldron : BEPauldron {
	BEEclipsePauldron() : base() {
		$this.Name               = 'Eclipse Pauldron'
		$this.MapObjName         = 'eclipsepauldron'
		$this.PurchasePrice      = 4750
		$this.SellPrice          = 2375
		$this.TargetStats        = @{
			[StatId]::Defense = 95
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Combines light and shadow, offering balanced protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
