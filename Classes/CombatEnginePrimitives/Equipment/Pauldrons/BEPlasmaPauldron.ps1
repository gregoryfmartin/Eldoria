using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPLASMAPAULDRON
#
###############################################################################

Class BEPlasmaPauldron : BEPauldron {
	BEPlasmaPauldron() : base() {
		$this.Name               = 'Plasma Pauldron'
		$this.MapObjName         = 'plasmapauldron'
		$this.PurchasePrice      = 4300
		$this.SellPrice          = 2150
		$this.TargetStats        = @{
			[StatId]::Defense = 86
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Generates a field of superheated plasma, for advanced warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
