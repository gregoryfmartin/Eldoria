using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAEGISPAULDRON
#
###############################################################################

Class BEAegisPauldron : BEPauldron {
	BEAegisPauldron() : base() {
		$this.Name               = 'Aegis Pauldron'
		$this.MapObjName         = 'aegispauldron'
		$this.PurchasePrice      = 6350
		$this.SellPrice          = 3175
		$this.TargetStats        = @{
			[StatId]::Defense = 127
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary shield, offering unparalleled defense against all threats.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
