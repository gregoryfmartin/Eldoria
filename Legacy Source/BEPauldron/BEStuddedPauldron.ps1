using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTUDDEDPAULDRON
#
###############################################################################

Class BEStuddedPauldron : BEPauldron {
	BEStuddedPauldron() : base() {
		$this.Name               = 'Studded Pauldron'
		$this.MapObjName         = 'studdedpauldron'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Leather pauldron reinforced with metal studs for added protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
