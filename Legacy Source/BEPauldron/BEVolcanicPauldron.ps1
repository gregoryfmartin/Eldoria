using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOLCANICPAULDRON
#
###############################################################################

Class BEVolcanicPauldron : BEPauldron {
	BEVolcanicPauldron() : base() {
		$this.Name               = 'Volcanic Pauldron'
		$this.MapObjName         = 'volcanicpauldron'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Forged in volcanic fires, resistant to extreme temperatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
