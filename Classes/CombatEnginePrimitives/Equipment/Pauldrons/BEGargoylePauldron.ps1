using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGARGOYLEPAULDRON
#
###############################################################################

Class BEGargoylePauldron : BEPauldron {
	BEGargoylePauldron() : base() {
		$this.Name               = 'Gargoyle Pauldron'
		$this.MapObjName         = 'gargoylepauldron'
		$this.PurchasePrice      = 5150
		$this.SellPrice          = 2575
		$this.TargetStats        = @{
			[StatId]::Defense = 103
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Made from hardened stone, incredibly tough and unyielding.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
