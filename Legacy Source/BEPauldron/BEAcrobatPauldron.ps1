using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEACROBATPAULDRON
#
###############################################################################

Class BEAcrobatPauldron : BEPauldron {
	BEAcrobatPauldron() : base() {
		$this.Name               = 'Acrobat Pauldron'
		$this.MapObjName         = 'acrobatpauldron'
		$this.PurchasePrice      = 8000
		$this.SellPrice          = 4000
		$this.TargetStats        = @{
			[StatId]::Defense = 160
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Provides protection without hindering agility and balance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
