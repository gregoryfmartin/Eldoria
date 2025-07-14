using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRIFFINPAULDRON
#
###############################################################################

Class BEGriffinPauldron : BEPauldron {
	BEGriffinPauldron() : base() {
		$this.Name               = 'Griffin Pauldron'
		$this.MapObjName         = 'griffinpauldron'
		$this.PurchasePrice      = 5250
		$this.SellPrice          = 2625
		$this.TargetStats        = @{
			[StatId]::Defense = 105
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and regal, allowing for swift aerial maneuvers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
